package main

import (
	"log"
	"net/http"
	"os"

	"github.com/gorilla/mux"
	"github.com/joho/godotenv"
	deliveryHttp "services/catalog_service/internal/delivery/http"
)

func main() {
	// Load .env.production
	if err := godotenv.Load(".env.production"); err != nil {
		log.Println("[CATALOG] No .env file - using environment variables")
	}

	port := os.Getenv("CATALOG_PORT")
	if port == "" {
		port = "8081"
	}

	r := mux.NewRouter()

	// Health Check
	r.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		w.Write([]byte(`{"service":"catalog","status":"UP"}`))
	}).Methods("GET")

	// Catalog API Routes
	handler := deliveryHttp.NewCatalogHandler()
	handler.RegisterRoutes(r)

	log.Printf("[CATALOG SERVICE] Starting on port %s with 1688 RapidAPI integration", port)
	if err := http.ListenAndServe(":"+port, r); err != nil {
		log.Fatalf("[CATALOG] Fatal error: %v", err)
	}
}
