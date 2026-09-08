package entity

import (
	"github.com/google/uuid"
	"time"
)

type ShipmentStatus string

const (
	StatusPreparing       ShipmentStatus = "PREPARING"
	StatusInTransit       ShipmentStatus = "IN_TRANSIT"
	StatusCustomsHold     ShipmentStatus = "CUSTOMS_HOLD"
	StatusOutForDelivery  ShipmentStatus = "OUT_FOR_DELIVERY"
	StatusDelivered       ShipmentStatus = "DELIVERED"
)

type Shipment struct {
	ID              uuid.UUID      `gorm:"type:uuid;primaryKey" json:"id"`
	OrderID         uuid.UUID      `gorm:"type:uuid;index" json:"order_id"`
	TrackingNumber  string         `gorm:"uniqueIndex" json:"tracking_number"`
	Carrier         string         `json:"carrier"`
	Status          ShipmentStatus `gorm:"type:varchar(20);default:'PREPARING'" json:"status"`
	EstimatedArrival time.Time     `json:"estimated_arrival"`
	Milestones      []Milestone    `gorm:"foreignKey:ShipmentID" json:"milestones,omitempty"`
	CreatedAt       time.Time      `json:"created_at"`
	UpdatedAt       time.Time      `json:"updated_at"`
}

type Milestone struct {
	ID          uuid.UUID `gorm:"type:uuid;primaryKey" json:"id"`
	ShipmentID  uuid.UUID `gorm:"type:uuid;index" json:"shipment_id"`
	Location    string    `json:"location"`
	Description string    `json:"description"`
	UpdatedAt   time.Time `json:"updated_at"`
}
