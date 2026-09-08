package main

import (
	"github.com/ahmedbaba/rfq-service/internal/api/http/handlers"
	"github.com/ahmedbaba/rfq-service/internal/config"
	"github.com/ahmedbaba/rfq-service/internal/domain/entity"
	"github.com/ahmedbaba/rfq-service/internal/infra/db"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"log"
	"net/http"
)

func main() {
	// 1. Setup Environment
	logger, _ := zap.NewProduction()
	cfg := config.LoadConfig()

	// 2. Persistence Layer
	pgDB := db.NewPostgresDB(cfg.Database.Dsn)
	pgDB.AutoMigrate(&entity.RFQ{}, &entity.Bid{})

	// 3. Application Logic
	rfqHandler := handlers.NewRFQHandler(pgDB)

	// 4. API Gateway Ingress
	r := gin.Default()
	
	v1 := r.Group("/v1/rfq")
	{
		v1.POST("/", rfqHandler.CreateRFQ)
		v1.GET("/open", rfqHandler.ListOpenRFQs)
		v1.POST("/:id/bid", rfqHandler.PlaceBid)
		v1.GET("/:id", func(c *gin.Context) {
			var rfq entity.RFQ
			if err := pgDB.Preload("Bids").First(&rfq, "id = ?", c.Param("id")).Error; err != nil {
				c.JSON(http.StatusNotFound, gin.H{"error": "RFQ not found"})
				return
			}
			c.JSON(http.StatusOK, rfq)
		})
	}

	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"service": "rfq_service", "status": "active"})
	})

	log.Printf("AhmedBaba RFQ & Sourcing Engine is live on :8083")
	r.Run(":8083")
}
