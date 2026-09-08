package usecase

import (
	"context"
	"log"
	"time"
	"services/catalog_service/internal/domain"
	"services/catalog_service/internal/infra/external"
)

type CatalogSyncEngine struct {
	repo          domain.ProductRepository
	apiClient     *external.OneSixEightEightClient
	markupPercent float64
}

func NewCatalogSyncEngine(repo domain.ProductRepository, client *external.OneSixEightEightClient, markup float64) *CatalogSyncEngine {
	return &CatalogSyncEngine{
		repo:          repo,
		apiClient:     client,
		markupPercent: markup,
	}
}

// StartSyncJob starts a periodic background sync to keep AhmedBaba prices fresh with 1688
func (s *CatalogSyncEngine) StartSyncJob(ctx context.Context, interval time.Duration) {
	ticker := time.NewTicker(interval)
	go func() {
		for {
			select {
			case <-ticker.C:
				log.Println("--- Starting Automated 1688 Sync ---")
				s.syncCatalogs(ctx)
			case <-ctx.Done():
				return
			}
		}
	}()
}

func (s *CatalogSyncEngine) syncCatalogs(ctx context.Context) {
	// 1. Fetch products that need update from local DB
	products, err := s.repo.GetAll(ctx)
	if err != nil {
		log.Printf("Sync Failed: Could not get products: %v", err)
		return
	}

	for _, p := range products {
		if p.SourcePlatform != "1688" {
			continue
		}

		// 2. Fetch fresh price from 1688 RapidAPI
		apiData, err := s.apiClient.FetchProductDetail(p.ID)
		if err != nil {
			log.Printf("Sync Warning: Failed to fetch detail for %s: %v", p.ID, err)
			continue
		}

		// 3. Apply Professional Markup logic
		// Original Price * (1 + Markup/100)
		for i, tier := range p.PriceTiers {
			// This logic assumes apiData returns original CNY price which we convert and markup
			p.PriceTiers[i].Price = tier.Price * (1 + s.markupPercent/100)
		}

		p.UpdatedAt = time.Now()
		
		// 4. Persistence
		err = s.repo.Update(ctx, p)
		if err != nil {
			log.Printf("Sync Error: Failed to save updated product %s: %v", p.ID, err)
		}
	}
	log.Println("--- Automated 1688 Sync Completed ---")
}
