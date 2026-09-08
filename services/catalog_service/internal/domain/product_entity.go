package domain

import "time"

// Product details extracted strictly corresponding to 1688/Alibaba schemas
type Product struct {
	ID                  string       `json:"id" bson:"_id"`
	SourcePlatform      string       `json:"source_platform" bson:"source_platform"` // e.g., "1688"
	Title               string       `json:"title" bson:"title"`
	Description         string       `json:"description" bson:"description"`
	Categories          []string     `json:"categories" bson:"categories"`
	Images              []string     `json:"images" bson:"images"`
	SupplierID          string       `json:"supplier_id" bson:"supplier_id"`
	PriceTiers          []PriceTier  `json:"price_tiers" bson:"price_tiers"` // MOQ pricing
	Variations          []Variation  `json:"variations" bson:"variations"`   // Colors, sizes, specs
	MinimumOrderQty     int          `json:"min_order_qty" bson:"min_order_qty"`
	HasTradeAssurance   bool         `json:"has_trade_assurance" bson:"has_trade_assurance"`
	IsVerifiedSupplier  bool         `json:"is_verified_supplier" bson:"is_verified_supplier"`
	ShippingLeadTimeDay int          `json:"shipping_lead_time_day" bson:"shipping_lead_time_day"`
	RatingScore         float64      `json:"rating_score" bson:"rating_score"`
	TotalSold           int          `json:"total_sold" bson:"total_sold"`
	CreatedAt           time.Time    `json:"created_at" bson:"created_at"`
	UpdatedAt           time.Time    `json:"updated_at" bson:"updated_at"`
}

type PriceTier struct {
	MinQuantity int     `json:"min_quantity" bson:"min_quantity"`
	MaxQuantity int     `json:"max_quantity" bson:"max_quantity"` // 0 if unlimited
	Price       float64 `json:"price" bson:"price"`
	Currency    string  `json:"currency" bson:"currency"`
}

type Variation struct {
	SKUCode    string            `json:"sku_code" bson:"sku_code"`
	Attributes map[string]string `json:"attributes" bson:"attributes"` // e.g. {"Color": "Red", "Size": "XL"}
	PriceOffset float64          `json:"price_offset" bson:"price_offset"`
	StockQty   int               `json:"stock_qty" bson:"stock_qty"`
	Image      string            `json:"image" bson:"image"`
}
