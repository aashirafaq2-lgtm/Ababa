package http

import (
	"encoding/json"
	"net/http"
	"os"
	"strconv"

	"github.com/gorilla/mux"
	"services/catalog_service/internal/infra/external"
	"go.uber.org/zap"
)

type CatalogHandler struct {
	apiClient *external.OneSixEightEightClient
	logger    *zap.Logger
}

func NewCatalogHandler() *CatalogHandler {
	logger, _ := zap.NewProduction()
	apiKey := os.Getenv("ONE_SIX_EIGHT_EIGHT_API_KEY")
	return &CatalogHandler{
		apiClient: external.New1688Client(apiKey, logger),
		logger:    logger,
	}
}

// GET /api/v1/catalog/product/{itemId}
func (h *CatalogHandler) GetProduct(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	itemId := vars["itemId"]

	data, err := h.apiClient.FetchProductDetail(itemId)
	if err != nil {
		h.logger.Error("Failed to get product", zap.Error(err))
		http.Error(w, `{"error":"Product not found"}`, http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(data)
}

// GET /api/v1/catalog/search?q=steel+pipes&page=1
func (h *CatalogHandler) SearchProducts(w http.ResponseWriter, r *http.Request) {
	query := r.URL.Query().Get("q")
	pageStr := r.URL.Query().Get("page")
	page, _ := strconv.Atoi(pageStr)
	if page == 0 {
		page = 1
	}

	if query == "" {
		http.Error(w, `{"error":"Search query required"}`, http.StatusBadRequest)
		return
	}

	data, err := h.apiClient.SearchProducts(query, page)
	if err != nil {
		h.logger.Error("Search failed", zap.Error(err))
		http.Error(w, `{"error":"Search failed"}`, http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(data)
}

// RegisterRoutes wires up routes to the Gorilla mux router
func (h *CatalogHandler) RegisterRoutes(r *mux.Router) {
	r.HandleFunc("/api/v1/catalog/product/{itemId}", h.GetProduct).Methods("GET")
	r.HandleFunc("/api/v1/catalog/search", h.SearchProducts).Methods("GET")
}
