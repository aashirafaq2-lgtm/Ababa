package handlers

import (
	"context"
	"github.com/ahmedbaba/auth-service/internal/domain/entity"
	"github.com/ahmedbaba/auth-service/internal/domain/repository"
	"github.com/ahmedbaba/auth-service/internal/domain/service"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"net/http"
	"time"
)

type AuthHandler struct {
	repo            repository.AuthRepository
	jwtService      *service.JWTService
	passwordService *service.PasswordService
	accessTokenTtl  int
	refreshTokenTtl int
}

func NewAuthHandler(repo repository.AuthRepository, jwt *service.JWTService, pwd *service.PasswordService, accTtl, refTtl int) *AuthHandler {
	return &AuthHandler{
		repo:            repo,
		jwtService:      jwt,
		passwordService: pwd,
		accessTokenTtl:  accTtl,
		refreshTokenTtl: refTtl,
	}
}

type RegisterRequest struct {
	Email    string    `json:"email" binding:"required,email"`
	Password string    `json:"password" binding:"required,min=8"`
	OrgID    uuid.UUID `json:"org_id"`
}

func (h *AuthHandler) Register(c *gin.Context) {
	var req RegisterRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	hash, _ := h.passwordService.HashPassword(req.Password)
	user := &entity.User{
		ID:           uuid.New(),
		Email:        req.Email,
		PasswordHash: hash,
		OrgID:        req.OrgID,
		Role:         "buyer", // Default
	}

	if err := h.repo.CreateUser(context.Background(), user); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create user"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message": "User registered successfully"})
}

type LoginRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required"`
}

func (h *AuthHandler) Login(c *gin.Context) {
	var req LoginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	user, err := h.repo.GetUserByEmail(context.Background(), req.Email)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
		return
	}

	match, _ := h.passwordService.ComparePassword(req.Password, user.PasswordHash)
	if !match {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
		return
	}

	accessToken, _ := h.jwtService.GenerateAccessToken(user.ID, user.OrgID, user.Role, h.accessTokenTtl)
	refreshToken := uuid.New().String()

	session := &entity.Session{
		UserID:       user.ID,
		RefreshToken: refreshToken,
		OrgID:        user.OrgID,
		Role:         user.Role,
		DeviceInfo:   c.Request.UserAgent(),
		ExpiresAt:    time.Now().Add(time.Duration(h.refreshTokenTtl) * time.Hour),
	}

	h.repo.StoreSession(context.Background(), session, h.refreshTokenTtl*3600)

	c.SetCookie("refresh_token", refreshToken, h.refreshTokenTtl*3600, "/", "", true, true)
	c.JSON(http.StatusOK, gin.H{
		"access_token": accessToken,
		"user_id":       user.ID,
		"org_id":        user.OrgID,
		"role":          user.Role,
	})
}

func (h *AuthHandler) Refresh(c *gin.Context) {
	refreshToken, err := c.Cookie("refresh_token")
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Refresh token missing"})
		return
	}

	session, err := h.repo.GetSession(context.Background(), refreshToken)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid session"})
		return
	}

	// Dynamic rotation: Issue new refresh token
	newRefreshToken := uuid.New().String()
	h.repo.DeleteSession(context.Background(), refreshToken)
	
	newSession := *session
	newSession.RefreshToken = newRefreshToken
	h.repo.StoreSession(context.Background(), &newSession, h.refreshTokenTtl*3600)

	accessToken, _ := h.jwtService.GenerateAccessToken(session.UserID, session.OrgID, session.Role, h.accessTokenTtl)

	c.SetCookie("refresh_token", newRefreshToken, h.refreshTokenTtl*3600, "/", "", true, true)
	c.JSON(http.StatusOK, gin.H{"access_token": accessToken})
}

func (h *AuthHandler) Logout(c *gin.Context) {
	refreshToken, _ := c.Cookie("refresh_token")
	if refreshToken != "" {
		h.repo.DeleteSession(context.Background(), refreshToken)
	}
	c.SetCookie("refresh_token", "", -1, "/", "", true, true)
	c.JSON(http.StatusOK, gin.H{"message": "Logged out successfully"})
}
