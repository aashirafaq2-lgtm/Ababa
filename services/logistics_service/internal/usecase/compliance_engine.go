package usecase

type TaxRate float64

type ComplianceEngine struct {
	rates map[string]TaxRate
}

func NewComplianceEngine() *ComplianceEngine {
	return &ComplianceEngine{
		rates: map[string]TaxRate{
			"IRQ": 0.15, // Iraq 15% Import Duty / Tax
			"PAK": 0.17, // Pakistan 17% GST
			"UAE": 0.05, // UAE 5% VAT
			"USA": 0.0,  // Variable, usually zero for B2B export
		},
	}
}

func (e *ComplianceEngine) CalculateLandedCost(baseAmount float64, countryCode string) float64 {
	rate, exists := e.rates[countryCode]
	if !exists {
		return baseAmount
	}
	
	taxAmount := baseAmount * float64(rate)
	return baseAmount + taxAmount
}
