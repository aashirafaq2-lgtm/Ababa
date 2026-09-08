package entity

import (
	"github.com/google/uuid"
	"time"
)

type OrganizationType string

const (
	OrgBuyer    OrganizationType = "BUYER"
	OrgSupplier OrganizationType = "SUPPLIER"
)

type Organization struct {
	ID        uuid.UUID        `gorm:"type:uuid;primaryKey" json:"id"`
	Name      string           `gorm:"not null" json:"name"`
	Type      OrganizationType `gorm:"type:varchar(20);not null" json:"type"`
	TaxID     string           `json:"tax_id"`
	KYCStatus string           `gorm:"default:'PENDING'" json:"kyc_status"`
	Members   []Member         `gorm:"foreignKey:OrgID" json:"members,omitempty"`
	CreatedAt time.Time        `json:"created_at"`
	UpdatedAt time.Time        `json:"updated_at"`
}

type Member struct {
	ID        uuid.UUID `gorm:"type:uuid;primaryKey" json:"id"`
	OrgID     uuid.UUID `gorm:"type:uuid;index" json:"org_id"`
	UserID    uuid.UUID `gorm:"type:uuid;index" json:"user_id"`
	Role      string    `gorm:"type:varchar(20);not null" json:"role"` // OWNER, ADMIN, MEMBER
	CreatedAt time.Time `json:"created_at"`
}

type Invitation struct {
	ID        uuid.UUID `gorm:"type:uuid;primaryKey" json:"id"`
	OrgID     uuid.UUID `gorm:"type:uuid;index" json:"org_id"`
	Email     string    `json:"email"`
	Role      string    `json:"role"`
	Status    string    `gorm:"default:'PENDING'" json:"status"` // PENDING, ACCEPTED, EXPIRED
	ExpiresAt time.Time `json:"expires_at"`
}
