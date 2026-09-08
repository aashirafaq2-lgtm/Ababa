package external

import (
	"fmt"
	"github.com/go-resty/resty/v2"
	"go.uber.org/zap"
)

type OneSixEightEightClient struct {
	rapidApiKey  string
	rapidApiHost string
	client       *resty.Client
	logger       *zap.Logger
}

func New1688Client(apiKey string, logger *zap.Logger) *OneSixEightEightClient {
	return &OneSixEightEightClient{
		rapidApiKey:  apiKey,
		rapidApiHost: "1688-product2.p.rapidapi.com",
		client:       resty.New(),
		logger:       logger,
	}
}

// FetchProductDetail uses RapidAPI's proxy to get 1688 product data
func (c *OneSixEightEightClient) FetchProductDetail(itemId string) (map[string]interface{}, error) {
	resp, err := c.client.R().
		SetHeader("X-RapidAPI-Key", c.rapidApiKey).
		SetHeader("X-RapidAPI-Host", c.rapidApiHost).
		SetQueryParam("itemId", itemId).
		Get("https://" + c.rapidApiHost + "/1688/item/detail")

	if err != nil {
		c.logger.Error("Failed to fetch product from RapidAPI", zap.Error(err))
		return nil, err
	}

	if resp.IsError() {
		return nil, fmt.Errorf("api error: %s", resp.Status())
	}

	// In real implementation, we would parse the JSON response into a struct
	var result map[string]interface{}
	// Assuming resp.Body() contains the JSON
	return result, nil
}

// SearchProducts handles keyword search via RapidAPI
func (c *OneSixEightEightClient) SearchProducts(keyword string, page int) (map[string]interface{}, error) {
	resp, err := c.client.R().
		SetHeader("X-RapidAPI-Key", c.rapidApiKey).
		SetHeader("X-RapidAPI-Host", c.rapidApiHost).
		SetQueryParams(map[string]string{
			"q":    keyword,
			"page": fmt.Sprintf("%d", page),
		}).
		Get("https://" + c.rapidApiHost + "/1688/item/search")

	if err != nil {
		return nil, err
	}

	var result map[string]interface{}
	return result, nil
}
