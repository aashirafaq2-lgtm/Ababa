package main

import (
	"github.com/ahmedbaba/inventory-service/internal/api/http/handlers"
	"github.com/ahmedbaba/inventory-service/internal/domain/entity"
	"github.com/gin-gonic/gin"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"log"
	"net/http"
	"os"
)

func main() {
	dsn := os.Getenv("DATABASE_DSN")
	if dsn == "" {
		dsn = "host=localhost user=admin password=admin dbname=ahmedbaba_inventory port=5432 sslmode=disable"
	}
	
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatalf("Failed to connect to DB: %v", err)
	}

	db.AutoMigrate(&entity.SupplierProduct{})

	r := gin.Default()
	handler := handlers.NewInventoryHandler(db)
	
	v1 := r.Group("/v1/inventory")
	{
		v1.POST("/products", handler.CreateProduct)
		v1.GET("/supplier/:id", handler.GetSupplierProducts)
	}

	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"status": "INVENTORY_SERVICE_READY"})
	})

	log.Println("AhmedBaba Inventory Service live on :8090")
	r.Run(":8090")
}
