package main

import (
	"github.com/ahmedbaba/auth-service/internal/api/http/handlers"
	"github.com/ahmedbaba/auth-service/internal/api/http/middleware"
	"github.com/ahmedbaba/auth-service/internal/config"
	"github.com/ahmedbaba/auth-service/internal/domain/service"
	"github.com/ahmedbaba/auth-service/internal/infra/db"
	"github.com/ahmedbaba/auth-service/internal/infra/redis"
	"github.com/ahmedbaba/auth-service/internal/pkg/logger"
	"github.com/gin-gonic/gin"
	"github.com/prometheus/client_golang/prometheus/promhttp"
	"net/http"
)

func main() {
	// 1. Initialize Core
	logger.InitLogger()
	cfg := config.LoadConfig()

	// 2. Initialize Infrastructure
	postgresDB := db.NewPostgresDB(cfg.Database.Dsn)
	redisClient := redis.NewRedisClient(cfg.Redis.Addr, cfg.Redis.Password, cfg.Redis.Db)
	
	// 3. Initialize Domain Services & Repositories
	repo := db.NewAuthRepository(postgresDB, redisClient)
	jwtService := service.NewJWTService(cfg.Auth.JwtSecret)
	passwordService := service.NewPasswordService()

	// 4. Initialize Handlers
	authHandler := handlers.NewAuthHandler(
		repo,
		jwtService,
		passwordService,
		cfg.Auth.AccessTokenTtl,
		cfg.Auth.RefreshTokenTtl,
	)

	// 5. Setup Router
	r := gin.New()
	r.Use(gin.Recovery())
	r.Use(middleware.PrometheusMiddleware())
	
	// Public Routes
	v1 := r.Group("/v1/auth")
	{
		v1.POST("/register", authHandler.Register)
		v1.POST("/login", authHandler.Login)
		v1.POST("/refresh", authHandler.Refresh)
		v1.POST("/logout", authHandler.Logout)
	}

	// Protected Routes Sample
	protected := r.Group("/v1")
	protected.Use(middleware.JWTMiddleware(jwtService))
	{
		protected.GET("/me", func(c *gin.Context) {
			userID, _ := c.Get("user_id")
			c.JSON(http.StatusOK, gin.H{"user_id": userID})
		})
		
		// Admin Only Sample
		admin := protected.Group("/admin")
		admin.Use(middleware.RoleGuard("super_admin"))
		{
			admin.GET("/stats", func(c *gin.Context) {
				c.JSON(http.StatusOK, gin.H{"status": "accessed"})
			})
		}
	}

	// Observability Endpoints
	r.GET("/metrics", gin.WrapH(promhttp.Handler()))
	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"status": "UP"})
	})

	// 6. Start Server
	logger.Log.Info("Starting AhmedBaba Auth Service on port " + cfg.Server.Port)
	if err := r.Run(":" + cfg.Server.Port); err != nil {
		logger.Log.Fatal("Failed to run server: " + err.Error())
	}
}
