package main

import (
	"github.com/ahmedbaba/notification-service/internal/api/http/handlers"
	"github.com/gin-gonic/gin"
	"log"
	"net/http"
)

func main() {
	r := gin.Default()
	
	handler := handlers.NewNotificationHandler()
	
	v1 := r.Group("/v1/notifications")
	{
		v1.POST("/send", handler.Send)
	}

	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"status": "NOTIFICATION_SERVICE_ACTIVE"})
	})

	log.Println("AhmedBaba Notification Service started on :8089")
	r.Run(":8089")
}
