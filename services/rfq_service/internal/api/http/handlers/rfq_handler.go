package handlers

import (
	"github.com/ahmedbaba/rfq-service/internal/domain/entity"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"gorm.io/gorm"
	"net/http"
)

type RFQHandler struct {
	db *gorm.DB
}

func NewRFQHandler(db *gorm.DB) *RFQHandler {
	return &RFQHandler{db: db}
}

type CreateRFQRequest struct {
	BuyerID        uuid.UUID `json:"buyer_id" binding:"required"`
	ProductName    string    `json:"product_name" binding:"required"`
	Quantity       int       `json:"quantity" binding:"required"`
	TargetPrice    float64   `json:"target_price"`
	Specifications string    `json:"specifications"`
}

func (h *RFQHandler) CreateRFQ(c *gin.Context) {
	var req CreateRFQRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	rfq := entity.RFQ{
		ID:             uuid.New(),
		BuyerID:        req.BuyerID,
		ProductName:    req.ProductName,
		Quantity:       req.Quantity,
		TargetPrice:    req.TargetPrice,
		Specifications: req.Specifications,
	}

	if err := h.db.Create(&rfq).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create RFQ"})
		return
	}

	c.JSON(http.StatusCreated, rfq)
}

type PlaceBidRequest struct {
	SupplierID   uuid.UUID `json:"supplier_id" binding:"required"`
	PriceOffered float64   `json:"price_offered" binding:"required"`
	DeliveryTime int       `json:"delivery_time_days" binding:"required"`
	Notes        string    `json:"notes"`
}

func (h *RFQHandler) PlaceBid(c *gin.Context) {
	rfqID, _ := uuid.Parse(c.Param("id"))
	var req PlaceBidRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	bid := entity.Bid{
		ID:           uuid.New(),
		RFQID:        rfqID,
		SupplierID:   req.SupplierID,
		PriceOffered: req.PriceOffered,
		DeliveryTime: req.DeliveryTime,
		Notes:        req.Notes,
	}

	if err := h.db.Create(&bid).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to place bid"})
		return
	}

	c.JSON(http.StatusCreated, bid)
}

func (h *RFQHandler) ListOpenRFQs(c *gin.Context) {
	var rfqs []entity.RFQ
	if err := h.db.Where("status = ?", entity.RFQStatusOpen).Find(&rfqs).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch RFQs"})
		return
	}
	c.JSON(http.StatusOK, rfqs)
}
