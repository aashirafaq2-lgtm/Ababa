package entity

import (
	"github.com/google/uuid"
	"time"
)

type SupplierProduct struct {
	ID          uuid.UUID `gorm:"type:uuid;primaryKey" json:"id"`
	SupplierID  uuid.UUID `gorm:"type:uuid;index" json:"supplier_id"`
	Title       string    `json:"title"`
	Description string    `json:"description"`
	BasePrice   float64   `json:"base_price"`
	StockQty    int       `json:"stock_qty"`
	Images      string    `json:"images"` // JSON string or comma-separated
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
}
