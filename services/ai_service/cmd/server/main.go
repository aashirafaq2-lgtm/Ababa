package main

import (
	"github.com/ahmedbaba/ai-service/internal/api/http/handlers"
	"github.com/ahmedbaba/ai-service/internal/config"
	"github.com/ahmedbaba/ai-service/internal/infra/llm"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"log"
	"net/http"
)

func main() {
	// 1. Setup
	logger, _ := zap.NewProduction()
	cfg := config.LoadConfig()

	// 2. Integration Layer
	llmClient := llm.NewLLMClient("PROJECT_AI_KEY", logger)
	aiHandler := handlers.NewAIHandler(llmClient)

	// 3. API Ingress
	r := gin.Default()
	
	v1 := r.Group("/v1/ai")
	{
		v1.POST("/translate", aiHandler.Translate)
		v1.POST("/suggest-negotiation", aiHandler.SuggestNegotiation)
	}

	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"service": "ai_service", "status": "intelligent"})
	})

	log.Printf("AhmedBaba AI & Negotiation Service is ready on :8086")
	r.Run(":8086")
}
