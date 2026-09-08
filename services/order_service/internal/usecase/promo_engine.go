package usecase

import (
	"errors"
	"time"
)

type Voucher struct {
	Code        string
	Amount      float64
	IsPercent   bool
	Expiry      time.Time
	MinOrderVal float64
}

type PromoEngine struct {
	vouchers map[string]Voucher
}

func NewPromoEngine() *PromoEngine {
	return &PromoEngine{
		vouchers: map[string]Voucher{
			"WELCOME_B2B": {Code: "WELCOME_B2B", Amount: 50.0, IsPercent: false, Expiry: time.Now().AddDate(1, 0, 0), MinOrderVal: 1000.0},
			"BULK_SOURCING": {Code: "BULK_SOURCING", Amount: 5.0, IsPercent: true, Expiry: time.Now().AddDate(0, 6, 0), MinOrderVal: 5000.0},
		},
	}
}

func (e *PromoEngine) ApplyVoucher(code string, orderTotal float64) (float64, error) {
	v, exists := e.vouchers[code]
	if !exists {
		return 0, errors.New("invalid voucher code")
	}

	if time.Now().After(v.Expiry) {
		return 0, errors.New("voucher expired")
	}

	if orderTotal < v.MinOrderVal {
		return 0, errors.New("minimum order value not met for this voucher")
	}

	discount := v.Amount
	if v.IsPercent {
		discount = orderTotal * (v.Amount / 100)
	}

	return discount, nil
}
