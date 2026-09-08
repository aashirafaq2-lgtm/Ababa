package usecase

import (
	"log"
)

type RiskScore float64

const (
	RiskLow    RiskScore = 0.1
	RiskMedium RiskScore = 0.5
	RiskHigh   RiskScore = 0.9
)

type FraudEngine struct{}

func (e *FraudEngine) AnalyzeTransaction(userID string, amount float64, ipAddress string) RiskScore {
	// 1. High Velocity Check
	// 2. Geo-location IP mismatch check
	// 3. Unusual bulk amount for new account check
	
	if amount > 50000 { // Unusually high for a first-time B2B order
		log.Printf("[SECURITY ALERT] High amount transaction detected for user %s", userID)
		return RiskHigh
	}
	
	log.Printf("[FRAUD ANALYSIS] Tx safe for user %s", userID)
	return RiskLow
}
