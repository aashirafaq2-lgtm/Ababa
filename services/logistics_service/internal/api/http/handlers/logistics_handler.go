package handlers

import (
	"github.com/ahmedbaba/logistics-service/internal/domain/entity"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"gorm.io/gorm"
	"net/http"
	"time"
)

type LogisticsHandler struct {
	db *gorm.DB
}

func NewLogisticsHandler(db *gorm.DB) *LogisticsHandler {
	return &LogisticsHandler{db: db}
}

type CreateShipmentRequest struct {
	OrderID         uuid.UUID `json:"order_id" binding:"required"`
	Carrier         string    `json:"carrier" binding:"required"`
	EstimatedArrival time.Time `json:"estimated_arrival"`
}

func (h *LogisticsHandler) CreateShipment(c *gin.Context) {
	var req CreateShipmentRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	shipment := entity.Shipment{
		ID:             uuid.New(),
		OrderID:        req.OrderID,
		TrackingNumber: "AB-" + uuid.New().String()[:8],
		Carrier:        req.Carrier,
		Status:         entity.StatusPreparing,
		EstimatedArrival: req.EstimatedArrival,
	}

	if err := h.db.Create(&shipment).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create shipment"})
		return
	}

	c.JSON(http.StatusCreated, shipment)
}

type AddMilestoneRequest struct {
	Location    string `json:"location" binding:"required"`
	Description string `json:"description" binding:"required"`
	Status      string `json:"status"` // Optional status update
}

func (h *LogisticsHandler) AddMilestone(c *gin.Context) {
	shipmentID, _ := uuid.Parse(c.Param("id"))
	var req AddMilestoneRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	milestone := entity.Milestone{
		ID:          uuid.New(),
		ShipmentID:  shipmentID,
		Location:    req.Location,
		Description: req.Description,
		UpdatedAt:   time.Now(),
	}

	err := h.db.Transaction(func(tx *gorm.DB) error {
		if err := tx.Create(&milestone).Error; err != nil {
			return err
		}

		if req.Status != "" {
			if err := tx.Model(&entity.Shipment{}).Where("id = ?", shipmentID).Update("status", req.Status).Error; err != nil {
				return err
			}
		}
		return nil
	})

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update shipment milestones"})
		return
	}

	c.JSON(http.StatusOK, milestone)
}

func (h *LogisticsHandler) GetTracking(c *gin.Context) {
	var shipment entity.Shipment
	if err := h.db.Preload("Milestones").Where("tracking_number = ?", c.Param("number")).First(&shipment).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Tracking number not found"})
		return
	}
	c.JSON(http.StatusOK, shipment)
}
