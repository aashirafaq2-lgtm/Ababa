package resilience

import (
	"context"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"
)

// GracefulShutdown ensures that the service closes connections properly before exiting
func GracefulShutdown(srv *http.Server) {
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, os.Interrupt, syscall.SIGTERM)
	<-quit
	log.Println("[RESILIENCE] Shutting down service gracefully...")

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	if err := srv.Shutdown(ctx); err != nil {
		log.Fatalf("[FATAL] Service shutdown failed: %v", err)
	}
	log.Println("[RESILIENCE] Service exited successfully")
}

// HealthHandler provides Kubernetes liveness/readiness probes
func HealthHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	w.Write([]byte(`{"status": "UP", "timestamp": "` + time.Now().Format(time.RFC3339) + `"}`))
}
