package search

import (
	"context"
	"github.com/olivere/elastic/v7"
	"log"
)

type SearchEngine struct {
	client *elastic.Client
}

func NewSearchEngine(url string) *SearchEngine {
	client, err := elastic.NewClient(
		elastic.SetURL(url),
		elastic.SetSniff(false),
	)
	if err != nil {
		log.Fatalf("Failed to connect to Elasticsearch: %v", err)
	}

	return &SearchEngine{client: client}
}

func (s *SearchEngine) IndexProduct(ctx context.Context, id string, product interface{}) error {
	_, err := s.client.Index().
		Index("products").
		Id(id).
		BodyJson(product).
		Do(ctx)
	return err
}

func (s *SearchEngine) SearchProducts(ctx context.Context, query string, from, size int) (*elastic.SearchResult, error) {
	q := elastic.NewMultiMatchQuery(query, "title", "description", "category_path").
		Type("best_fields").
		Fuzziness("AUTO")

	return s.client.Search().
		Index("products").
		Query(q).
		From(from).
		Size(size).
		Do(ctx)
}
```go
