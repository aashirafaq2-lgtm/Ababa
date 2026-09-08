package entity

import (
	"github.com/google/uuid"
	"time"
)

type Session struct {
	UserID       uuid.UUID `json:"user_id"`
	RefreshToken string    `json:"refresh_token"`
	OrgID        uuid.UUID `json:"org_id"`
	Role         string    `json:"role"`
	DeviceInfo   string    `json:"device_info"`
	ExpiresAt    time.Time `json:"expires_at"`
}
