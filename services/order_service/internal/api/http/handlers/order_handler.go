package handlers

import (
	"github.com/ahmedbaba/order-service/internal/app/escrow"
	"github.com/ahmedbaba/order-service/internal/domain/entity"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"gorm.io/gorm"
	"net/http"
)

type OrderHandler struct {
	db     *gorm.DB
	escrow *escrow.EscrowManager
}

func NewOrderHandler(db *gorm.DB, e *escrow.EscrowManager) *OrderHandler {
	return &OrderHandler{db: db, escrow: e}
}

type CreateOrderRequest struct {
	BuyerID    uuid.UUID `json:"buyer_id" binding:"required"`
	SupplierID uuid.UUID `json:"supplier_id" binding:"required"`
	ProductID  string    `json:"product_id" binding:"required"`
	Amount     float64   `json:"amount" binding:"required"`
}

func (h *OrderHandler) CreateOrder(c *gin.Context) {
	var req CreateOrderRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	order := entity.Order{
		ID:              uuid.New(),
		BuyerID:         req.BuyerID,
		SupplierID:      req.SupplierID,
		ProductID:       req.ProductID,
		Amount:          req.Amount,
		Status:          entity.StatusAwaitingPayment,
		EscrowReference: uuid.New().String(), // Unique escrow session
	}

	if err := h.db.Create(&order).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create order"})
		return
	}

	c.JSON(http.StatusCreated, order)
}

func (h *OrderHandler) ConfirmPayment(c *gin.Context) {
	orderID := c.Param("id")
	if err := h.escrow.TransitionToInEscrow(c.Request.Context(), orderID); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "CONFIRMED_IN_ESCROW"})
}
