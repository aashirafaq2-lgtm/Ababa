package entity

import (
	"github.com/google/uuid"
	"time"
)

type RFQStatus string

const (
	RFQStatusOpen      RFQStatus = "OPEN"
	RFQStatusClosed    RFQStatus = "CLOSED"
	RFQStatusAwarded   RFQStatus = "AWARDED"
	RFQStatusCancelled RFQStatus = "CANCELLED"
)

type RFQ struct {
	ID             uuid.UUID `gorm:"type:uuid;primaryKey" json:"id"`
	BuyerID        uuid.UUID `gorm:"type:uuid;index" json:"buyer_id"`
	ProductName    string    `json:"product_name"`
	Quantity       int       `json:"quantity"`
	TargetPrice    float64   `json:"target_price"`
	Specifications string    `gorm:"type:text" json:"specifications"`
	Status         RFQStatus `gorm:"type:varchar(20);default:'OPEN'" json:"status"`
	Bids           []Bid     `gorm:"foreignKey:RFQID" json:"bids,omitempty"`
	CreatedAt      time.Time `json:"created_at"`
	UpdatedAt      time.Time `json:"updated_at"`
}

type Bid struct {
	ID           uuid.UUID `gorm:"type:uuid;primaryKey" json:"id"`
	RFQID        uuid.UUID `gorm:"type:uuid;index" json:"rfq_id"`
	SupplierID   uuid.UUID `gorm:"type:uuid;index" json:"supplier_id"`
	PriceOffered float64   `json:"price_offered"`
	DeliveryTime int       `json:"delivery_time_days"` // Days
	Notes        string    `json:"notes"`
	IsSelected   bool      `gorm:"default:false" json:"is_selected"`
	CreatedAt    time.Time `json:"created_at"`
}
