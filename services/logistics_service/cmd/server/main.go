package main

import (
	"github.com/ahmedbaba/logistics-service/internal/api/http/handlers"
	"github.com/ahmedbaba/logistics-service/internal/config"
	"github.com/ahmedbaba/logistics-service/internal/domain/entity"
	"github.com/ahmedbaba/logistics-service/internal/infra/db"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"log"
	"net/http"
)

func main() {
	// 1. Initialize
	logger, _ := zap.NewProduction()
	cfg := config.LoadConfig()

	// 2. Database
	pgDB := db.NewPostgresDB(cfg.Database.Dsn)
	pgDB.AutoMigrate(&entity.Shipment{}, &entity.Milestone{})

	// 3. Application handlers
	logisticsHandler := handlers.NewLogisticsHandler(pgDB)

	// 4. API Ingress
	r := gin.Default()
	
	v1 := r.Group("/v1/logistics")
	{
		v1.POST("/shipments", logisticsHandler.CreateShipment)
		v1.GET("/track/:number", logisticsHandler.GetTracking)
		v1.POST("/shipments/:id/milestones", logisticsHandler.AddMilestone)
	}

	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"service": "logistics_service", "status": "operational"})
	})

	log.Printf("AhmedBaba Logistics & Tracking Service is active on :8084")
	r.Run(":8084")
}
