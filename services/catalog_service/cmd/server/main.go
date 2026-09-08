package main

import (
	"context"
	"github.com/ahmedbaba/catalog-service/internal/app/sync"
	"github.com/ahmedbaba/catalog-service/internal/config"
	"github.com/ahmedbaba/catalog-service/internal/infra/db"
	"github.com/ahmedbaba/catalog-service/internal/infra/search"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"log"
	"net/http"
)

func main() {
	// 1. Initialize Logger
	logger, _ := zap.NewProduction()
	defer logger.Sync()

	// 2. Load Config
	cfg := config.LoadConfig()

	// 3. Connect Infrastructure
	mongoClient := db.NewMongoClient(cfg.Mongo.Uri)
	database := mongoClient.Database(cfg.Mongo.Db)
	searchEngine := search.NewSearchEngine(cfg.Elasticsearch.Url)

	// 4. Initialize Core Logic
	syncEngine := sync.NewSyncEngine(database, searchEngine, logger)

	// 5. Build REST API Gateway for internal management
	r := gin.Default()
	
	// Search Endpoint
	r.GET("/v1/search", func(c *gin.Context) {
		query := c.Query("q")
		results, err := searchEngine.SearchProducts(context.Background(), query, 0, 20)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, results)
	})

	// Trigger Sync Endpoint (Called by 1688 Webhooks or Schedulers)
	r.POST("/v1/sync/:product_id", func(c *gin.Context) {
		// In production, this would call 1688 SDK to fetch product details
		mockRawData := map[string]interface{}{
			"productID": c.Param("product_id"),
			"subject":   "Synced Product from 1688",
			"image": map[string]interface{}{
				"images": []interface{}{"https://img.alicdn.com/mock.jpg"},
			},
		}
		
		err := syncEngine.Process1688Product(context.Background(), mockRawData)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, gin.H{"status": "synchronized"})
	})

	log.Printf("AhmedBaba Catalog Service is live on port %s", cfg.Server.Port)
	r.Run(":" + cfg.Server.Port)
}
