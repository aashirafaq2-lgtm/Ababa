package main

import (
	"github.com/ahmedbaba/org-service/internal/api/http/handlers"
	"github.com/ahmedbaba/org-service/internal/config"
	"github.com/ahmedbaba/org-service/internal/domain/entity"
	"github.com/ahmedbaba/org-service/internal/infra/db"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"log"
	"net/http"
)

func main() {
	// 1. Core Startup
	logger, _ := zap.NewProduction()
	cfg := config.LoadConfig()

	// 2. Persistence Layer
	pgDB := db.NewPostgresDB(cfg.Database.Dsn)
	pgDB.AutoMigrate(&entity.Organization{}, &entity.Member{}, &entity.Invitation{})

	// 3. Handlers
	orgHandler := handlers.NewOrgHandler(pgDB)

	// 4. API Mesh Ingress
	r := gin.Default()
	
	v1 := r.Group("/v1/organizations")
	{
		v1.POST("/", orgHandler.CreateOrganization)
		v1.GET("/user", orgHandler.ListUserOrganizations)
		v1.POST("/:id/invites", orgHandler.InviteMember)
		
		v1.GET("/:id", func(c *gin.Context) {
			var org entity.Organization
			if err := pgDB.Preload("Members").First(&org, "id = ?", c.Param("id")).Error; err != nil {
				c.JSON(http.StatusNotFound, gin.H{"error": "Organization not found"})
				return
			}
			c.JSON(http.StatusOK, org)
		})
	}

	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"service": "org_service", "status": "active"})
	})

	log.Printf("AhmedBaba Organization & Tenant Service is operational on :8085")
	r.Run(":8085")
}
