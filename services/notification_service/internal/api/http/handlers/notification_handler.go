package handlers

import (
	"github.com/ahmedbaba/notification-service/internal/domain/entity"
	"github.com/gin-gonic/gin"
	"net/http"
	"time"
)

type NotificationHandler struct{}

func NewNotificationHandler() *NotificationHandler {
	return &NotificationHandler{}
}

type SendNotificationRequest struct {
	UserID  string                  `json:"user_id" binding:"required"`
	Type    entity.NotificationType `json:"type" binding:"required"`
	Title   string                  `json:"title" binding:"required"`
	Content string                  `json:"content" binding:"required"`
}

func (h *NotificationHandler) Send(c *gin.Context) {
	var req SendNotificationRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Integration Point: Call FCM / SendGrid / Twilio
	// For production, this is orchestrated via a task queue (e.g. RabbitMQ/SQS)
	
	notification := entity.Notification{
		ID:        "NOTI-" + time.Now().Format("20060102150405"),
		UserID:    req.UserID,
		Type:      req.Type,
		Title:     req.Title,
		Content:   req.Content,
		Status:    "SENT",
		CreatedAt: time.Now(),
	}

	c.JSON(http.StatusAccepted, notification)
}
