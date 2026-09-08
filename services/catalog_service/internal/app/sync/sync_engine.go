package sync

import (
	"context"
	"github.com/ahmedbaba/catalog-service/internal/domain/entity"
	"github.com/ahmedbaba/catalog-service/internal/infra/search"
	"go.mongodb.org/mongo-driver/mongo"
	"go.uber.org/zap"
	"time"
)

type SyncEngine struct {
	db     *mongo.Database
	search *search.SearchEngine
	logger *zap.Logger
}

func NewSyncEngine(db *mongo.Database, search *search.SearchEngine, logger *zap.Logger) *SyncEngine {
	return &SyncEngine{
		db:     db,
		search: search,
		logger: logger,
	}
}

func (e *SyncEngine) Process1688Product(ctx context.Context, rawData map[string]interface{}) error {
	// Normalization Logic: Mapping 1688 API raw response to AhmedBaba Internal Entity
	product := &entity.Product{
		ID:           rawData["productID"].(string),
		OriginalID:   rawData["productID"].(string),
		Title:        rawData["subject"].(string), // Direct mapping from 1688 'subject'
		MainImage:    rawData["image"].(map[string]interface{})["images"].([]interface{})[0].(string),
		LastSyncedAt: time.Now(),
		IsVisible:    true,
	}

	// 1. Persist to MongoDB (Source of Truth)
	collection := e.db.Collection("products")
	_, err := collection.ReplaceOne(ctx, map[string]string{"_id": product.ID}, product, nil)
	if err != nil {
		e.logger.Error("Failed to persist product to Mongo", zap.Error(err))
		return err
	}

	// 2. Index to Elasticsearch (Discovery Layer)
	err = e.search.IndexProduct(ctx, product.ID, product)
	if err != nil {
		e.logger.Error("Failed to index product to Elastic", zap.Error(err))
		return err
	}

	return nil
}
