package usecase

import (
	"log"
)

type CurrencyConverter struct {
	rates map[string]float64
}

func NewCurrencyConverter() *CurrencyConverter {
	return &CurrencyConverter{
		rates: map[string]float64{
			"USD": 1.0,
			"IQD": 1310.0, // Iraq Dinar
			"AED": 3.67,   // UAE Dirham
			"PKR": 280.0,  // Pakistan Rupee
			"CNY": 7.20,   // Chinese Yuan
		},
	}
}

// Convert converts the base 1688 price (usually in USD or CNY) to the buyer's local currency
func (c *CurrencyConverter) Convert(amount float64, from, to string) float64 {
	baseRate, ok1 := c.rates[from]
	targetRate, ok2 := c.rates[to]
	
	if !ok1 || !ok2 {
		log.Printf("[CURRENCY] Unsupported currency pair: %s to %s", from, to)
		return amount
	}
	
	// amount / baseRate = USD value, then * targetRate
	return (amount / baseRate) * targetRate
}
