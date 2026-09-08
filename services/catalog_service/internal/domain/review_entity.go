package domain

import (
	"time"
)

type Review struct {
	ID         string    `json:"id" bson:"_id"`
	ProductID  string    `json:"product_id" bson:"product_id"`
	BuyerID    string    `json:"buyer_id" bson:"buyer_id"`
	Rating     int       `json:"rating" bson:"rating"` // 1-5
	Content    string    `json:"content" bson:"content"`
	Images     []string  `json:"images" bson:"images"`
	IsVerified bool      `json:"is_verified" bson:"is_verified"` // Verified Purchase
	CreatedAt  time.Time `json:"created_at" bson:"created_at"`
}

type ReviewRepository interface {
	AddReview(review *Review) error
	GetByProduct(productID string) ([]*Review, error)
	GetAverageRating(productID string) (float64, error)
}
