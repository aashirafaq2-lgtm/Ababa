package usecase

import (
	"fmt"
)

type TransitMode string

const (
	AirFreight   TransitMode = "AIR"
	SeaFreight   TransitMode = "SEA"
	RoadFreight  TransitMode = "ROAD"
)

type LogisticsCalculator struct {
	baseRateSea float64 // Price per Cubic Meter (CBM)
	baseRateAir float64 // Price per Kilogram (Kg)
}

func NewLogisticsCalculator() *LogisticsCalculator {
	return &LogisticsCalculator{
		baseRateSea: 120.0, // Example $120 per CBM
		baseRateAir: 12.5,  // Example $12.5 per Kg
	}
}

// CalculateEstimate provides a shipping cost estimate for B2B bulk orders
func (c *LogisticsCalculator) CalculateEstimate(weight float64, volume float64, mode TransitMode) (float64, error) {
	switch mode {
	case AirFreight:
		// Air follows Volumetric Weight logic: (Vol in cm3 / 6000)
		return weight * c.baseRateAir, nil
	case SeaFreight:
		// Sea typically charged by CBM
		return volume * c.baseRateSea, nil
	default:
		return 0, fmt.Errorf("unsupported transit mode")
	}
}
