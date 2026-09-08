package repository

import (
	"context"
	"github.com/ahmedbaba/auth-service/internal/domain/entity"
	"github.com/google/uuid"
)

type AuthRepository interface {
	CreateUser(ctx context.Context, user *entity.User) error
	GetUserByEmail(ctx context.Context, email string) (*entity.User, error)
	GetUserByID(ctx context.Context, id uuid.UUID) (*entity.User, error)
	
	StoreSession(ctx context.Context, session *entity.Session, ttlSeconds int) error
	GetSession(ctx context.Context, refreshToken string) (*entity.Session, error)
	DeleteSession(ctx context.Context, refreshToken string) error
	RevokeAllUserSessions(ctx context.Context, userID uuid.UUID) error
}
