package usecase

import (
	"time"
)

type InspectionStatus string

const (
	InspectionRequested InspectionStatus = "REQUESTED"
	InspectionScheduled InspectionStatus = "SCHEDULED"
	InspectionPass      InspectionStatus = "PASSED"
	InspectionFail      InspectionStatus = "FAILED"
)

type InspectionService struct {
	ID        string           `json:"id"`
	OrderID   string           `json:"order_id"`
	VendorID  string           `json:"vendor_id"` // RedT inspection, etc.
	Status    InspectionStatus `json:"status"`
	ReportURL string           `json:"report_url"`
	Passed    bool             `json:"passed"`
	CheckedAt time.Time        `json:"checked_at"`
}

type VerificationManager struct{}

func (m *VerificationManager) RequestInitialInspection(orderID string) *InspectionService {
	// Logic to notify third-party inspectors
	return &InspectionService{
		ID:      "INSP-" + time.Now().Format("20060102"),
		OrderID: orderID,
		Status:  InspectionRequested,
	}
}
