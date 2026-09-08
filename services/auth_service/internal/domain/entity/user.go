package entity

import (
	"github.com/google/uuid"
	"time"
)

type User struct {
	ID           uuid.UUID `gorm:"type:uuid;primaryKey;default:uuid_generate_v4()"`
	Email        string    `gorm:"uniqueIndex;not null"`
	Phone        string    `gorm:"uniqueIndex"`
	PasswordHash string    `gorm:"not null"`
	OrgID        uuid.UUID `gorm:"type:uuid;index"`
	Role         string    `gorm:"not null;default:'buyer'"`
	IsActive     bool      `gorm:"default:true"`
	MfaEnabled   bool      `gorm:"default:false"`
	MfaSecret    string
	CreatedAt    time.Time
	UpdatedAt    time.Time
}
