package domain

import (
	"time"
)

type OrderStatus string

const (
	StatusPendingPayment    OrderStatus = "PENDING_PAYMENT"
	StatusEscrowed          OrderStatus = "ESCROWED"           // Payment received but held
	StatusShipped           OrderStatus = "SHIPPED"
	StatusDelivered         OrderStatus = "DELIVERED"
	StatusCompleted         OrderStatus = "COMPLETED"         // Funds released to supplier
	StatusDisputed          OrderStatus = "DISPUTED"
)

type Order struct {
	ID              string      `gorm:"primaryKey" json:"id"`
	BuyerID         string      `json:"buyer_id"`
	SupplierID      string      `json:"supplier_id"`
	ProductID       string      `json:"product_id"`
	Quantity        int         `json:"quantity"`
	UnitPrice       float64     `json:"unit_price"`
	TotalPrice      float64     `json:"total_price"`
	Currency        string      `json:"currency"`
	Status          OrderStatus `json:"status"`
	IncoTerm        string      `json:"inco_term"` // FOB, EXW, DDP
	ShippingCarrier string      `json:"shipping_carrier"`
	TrackingNumber  string      `json:"tracking_number"`
	CreatedAt       time.Time   `json:"created_at"`
	UpdatedAt       time.Time   `json:"updated_at"`
}

type OrderRepository interface {
	Create(order *Order) error
	GetByID(id string) (*Order, error)
	UpdateStatus(id string, status OrderStatus) error
	GetByBuyer(buyerID string) ([]*Order, error)
}
