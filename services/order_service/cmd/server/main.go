package main

import (
	"github.com/ahmedbaba/order-service/internal/api/http/handlers"
	"github.com/ahmedbaba/order-service/internal/app/escrow"
	"github.com/ahmedbaba/order-service/internal/config"
	"github.com/ahmedbaba/order-service/internal/domain/entity"
	"github.com/ahmedbaba/order-service/internal/infra/db"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"log"
	"net/http"
)

func main() {
	// 1. Core Services
	logger, _ := zap.NewProduction()
	cfg := config.LoadConfig()

	// 2. Database & Migrations
	pgDB := db.NewPostgresDB(cfg.Database.Dsn)
	pgDB.AutoMigrate(&entity.Order{}, &entity.Transaction{})

	// 3. Logic Layer
	escrowMgr := escrow.NewEscrowManager(pgDB, logger)
	orderHander := handlers.NewOrderHandler(pgDB, escrowMgr)

	// 4. Router
	r := gin.Default()
	
	v1 := r.Group("/v1/orders")
	{
		v1.POST("/", orderHander.CreateOrder)
		v1.POST("/:id/confirm-payment", orderHander.ConfirmPayment)
		v1.GET("/:id", func(c *gin.Context) {
			var order entity.Order
			if err := pgDB.First(&order, "id = ?", c.Param("id")).Error; err != nil {
				c.JSON(http.StatusNotFound, gin.H{"error": "Order not found"})
				return
			}
			c.JSON(http.StatusOK, order)
		})
	}

	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"service": "order_service", "status": "healthy"})
	})

	log.Printf("AhmedBaba Order & Escrow Service is operational on :8082")
	r.Run(":8082")
}
