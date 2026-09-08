package usecase

import (
	"context"
	"testing"
	"services/catalog_service/internal/domain"
)

// mockRepo implements domain.ProductRepository for testing
type mockRepo struct {
	products []*domain.Product
}

func (m *mockRepo) GetAll(ctx context.Context) ([]*domain.Product, error) {
	return m.products, nil
}

func (m *mockRepo) Update(ctx context.Context, p *domain.Product) error {
	return nil
}

func (m *mockRepo) GetByID(ctx context.Context, id string) (*domain.Product, error) { return nil, nil }
func (m *mockRepo) Create(ctx context.Context, p *domain.Product) error             { return nil }

func TestMarkupCalculation(t *testing.T) {
	testProduct := &domain.Product{
		ID:             "1688_TEST_1",
		SourcePlatform: "1688",
		PriceTiers: []domain.PriceTier{
			{MinQuantity: 1, Price: 100.0}, // Original Price
		},
	}

	repo := &mockRepo{products: []*domain.Product{testProduct}}
	engine := NewCatalogSyncEngine(repo, nil, 15.0) // 15% Markup

	engine.syncCatalogs(context.Background())

	expected := 115.0
	actual := testProduct.PriceTiers[0].Price

	if actual != expected {
		t.Errorf("Markup failed: expected %f, got %f", expected, actual)
	}
}
