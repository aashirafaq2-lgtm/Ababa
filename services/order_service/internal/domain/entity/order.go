package entity

import (
	"github.com/google/uuid"
	"time"
)

type OrderStatus string

const (
	StatusAwaitingPayment OrderStatus = "AWAITING_PAYMENT"
	StatusInEscrow        OrderStatus = "IN_ESCROW"
	StatusShipped         OrderStatus = "SHIPPED"
	StatusDelivered       OrderStatus = "DELIVERED"
	StatusCompleted       OrderStatus = "COMPLETED"
	StatusRefunded        OrderStatus = "REFUNDED"
	StatusDisputed        OrderStatus = "DISPUTED"
)

type Order struct {
	ID              uuid.UUID   `gorm:"type:uuid;primaryKey" json:"id"`
	BuyerID         uuid.UUID   `gorm:"type:uuid;index" json:"buyer_id"`
	SupplierID      uuid.UUID   `gorm:"type:uuid;index" json:"supplier_id"`
	ProductID       string      `gorm:"not null" json:"product_id"`
	Amount          float64     `gorm:"type:decimal(15,2);not null" json:"amount"`
	Currency        string      `gorm:"type:varchar(3);default:'USD'" json:"currency"`
	Status          OrderStatus `gorm:"type:varchar(20);default:'AWAITING_PAYMENT'" json:"status"`
	EscrowReference string      `gorm:"uniqueIndex" json:"escrow_ref"`
	CreatedAt       time.Time   `json:"created_at"`
	UpdatedAt       time.Time   `json:"updated_at"`
}

type Transaction struct {
	ID          uuid.UUID `gorm:"type:uuid;primaryKey"`
	OrderID     uuid.UUID `gorm:"type:uuid;index"`
	Amount      float64   `gorm:"type:decimal(15,2)"`
	Type        string    `gorm:"type:varchar(20)"` // DEPOSIT, RELEASE, REFUND
	LedgerEntry string    `gorm:"type:text"`
	CreatedAt   time.Time
}
