package db

import (
	"context"
	"encoding/json"
	"fmt"
	"github.com/ahmedbaba/auth-service/internal/domain/entity"
	"github.com/ahmedbaba/auth-service/internal/domain/repository"
	"github.com/google/uuid"
	"github.com/redis/go-redis/v9"
	"gorm.io/gorm"
	"time"
)

type authRepositoryImpl struct {
	db  *gorm.DB
	rdb *redis.Client
}

func NewAuthRepository(db *gorm.DB, rdb *redis.Client) repository.AuthRepository {
	return &authRepositoryImpl{db: db, rdb: rdb}
}

func (r *authRepositoryImpl) CreateUser(ctx context.Context, user *entity.User) error {
	return r.db.WithContext(ctx).Create(user).Error
}

func (r *authRepositoryImpl) GetUserByEmail(ctx context.Context, email string) (*entity.User, error) {
	var user entity.User
	if err := r.db.WithContext(ctx).Where("email = ?", email).First(&user).Error; err != nil {
		return nil, err
	}
	return &user, nil
}

func (r *authRepositoryImpl) GetUserByID(ctx context.Context, id uuid.UUID) (*entity.User, error) {
	var user entity.User
	if err := r.db.WithContext(ctx).First(&user, id).Error; err != nil {
		return nil, err
	}
	return &user, nil
}

func (r *authRepositoryImpl) StoreSession(ctx context.Context, session *entity.Session, ttlSeconds int) error {
	key := fmt.Sprintf("session:%s", session.RefreshToken)
	data, err := json.Marshal(session)
	if err != nil {
		return err
	}
	
	// Store individual session
	if err := r.rdb.Set(ctx, key, data, time.Duration(ttlSeconds)*time.Second).Err(); err != nil {
		return err
	}
	
	// Track session per user for global revocation
	userSessionsKey := fmt.Sprintf("user_sessions:%s", session.UserID)
	return r.rdb.SAdd(ctx, userSessionsKey, session.RefreshToken).Err()
}

func (r *authRepositoryImpl) GetSession(ctx context.Context, refreshToken string) (*entity.Session, error) {
	key := fmt.Sprintf("session:%s", refreshToken)
	data, err := r.rdb.Get(ctx, key).Bytes()
	if err != nil {
		return nil, err
	}
	
	var session entity.Session
	if err := json.Unmarshal(data, &session); err != nil {
		return nil, err
	}
	return &session, nil
}

func (r *authRepositoryImpl) DeleteSession(ctx context.Context, refreshToken string) error {
	session, err := r.GetSession(ctx, refreshToken)
	if err == nil {
		userSessionsKey := fmt.Sprintf("user_sessions:%s", session.UserID)
		r.rdb.SRem(ctx, userSessionsKey, refreshToken)
	}
	
	key := fmt.Sprintf("session:%s", refreshToken)
	return r.rdb.Del(ctx, key).Err()
}

func (r *authRepositoryImpl) RevokeAllUserSessions(ctx context.Context, userID uuid.UUID) error {
	userSessionsKey := fmt.Sprintf("user_sessions:%s", userID)
	tokens, err := r.rdb.SMembers(ctx, userSessionsKey).Result()
	if err != nil {
		return err
	}
	
	for _, token := range tokens {
		r.DeleteSession(ctx, token)
	}
	
	return r.rdb.Del(ctx, userSessionsKey).Err()
}
