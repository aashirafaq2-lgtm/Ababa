package handlers

import (
	"github.com/ahmedbaba/org-service/internal/domain/entity"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"gorm.io/gorm"
	"net/http"
	"time"
)

type OrgHandler struct {
	db *gorm.DB
}

func NewOrgHandler(db *gorm.DB) *OrgHandler {
	return &OrgHandler{db: db}
}

type CreateOrgRequest struct {
	Name string                  `json:"name" binding:"required"`
	Type entity.OrganizationType `json:"type" binding:"required"`
	OwnerID uuid.UUID            `json:"owner_id" binding:"required"`
}

func (h *OrgHandler) CreateOrganization(c *gin.Context) {
	var req CreateOrgRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	orgID := uuid.New()
	org := entity.Organization{
		ID:   orgID,
		Name: req.Name,
		Type: req.Type,
	}

	member := entity.Member{
		ID:     uuid.New(),
		OrgID:  orgID,
		UserID: req.OwnerID,
		Role:   "OWNER",
	}

	err := h.db.Transaction(func(tx *gorm.DB) error {
		if err := tx.Create(&org).Error; err != nil {
			return err
		}
		return tx.Create(&member).Error
	})

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to initialize organization ecosystem"})
		return
	}

	c.JSON(http.StatusCreated, org)
}

func (h *OrgHandler) ListUserOrganizations(c *gin.Context) {
	userID, _ := uuid.Parse(c.Query("user_id"))
	
	var members []entity.Member
	if err := h.db.Preload("Organization").Where("user_id = ?", userID).Find(&members).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch user organizations"})
		return
	}

	c.JSON(http.StatusOK, members)
}

type InviteMemberRequest struct {
	Email string `json:"email" binding:"required,email"`
	Role  string `json:"role" binding:"required"`
}

func (h *OrgHandler) InviteMember(c *gin.Context) {
	orgID, _ := uuid.Parse(c.Param("id"))
	var req InviteMemberRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	invite := entity.Invitation{
		ID:        uuid.New(),
		OrgID:     orgID,
		Email:     req.Email,
		Role:      req.Role,
		ExpiresAt: time.Now().Add(72 * time.Hour),
	}

	if err := h.db.Create(&invite).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create invitation"})
		return
	}

	c.JSON(http.StatusCreated, invite)
}
```go
