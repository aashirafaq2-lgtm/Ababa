package usecase

import (
	"errors"
	"services/order_service/internal/domain"
	"time"
)

type DisputeStatus string

const (
	DisputeStatusOpen      DisputeStatus = "OPEN"
	DisputeStatusInReview  DisputeStatus = "IN_REVIEW"
	DisputeStatusResolved  DisputeStatus = "RESOLVED"
	DisputeStatusRejected  DisputeStatus = "REJECTED"
)

type Dispute struct {
	ID          string        `json:"id"`
	OrderID     string        `json:"order_id"`
	BuyerID     string        `json:"buyer_id"`
	Reason      string        `json:"reason"`
	Description string        `json:"description"`
	Evidence    []string      `json:"evidence_urls"` // S3 links to photos/videos
	Status      DisputeStatus `json:"status"`
	CreatedAt   time.Time     `json:"created_at"`
}

type DisputeService interface {
	OpenDispute(orderID, reason, desc string, evidence []string) (*Dispute, error)
	ResolveDispute(disputeID string, refundAmount float64) error
}

type disputeHandler struct {
	repo       domain.OrderRepository
	// ... other dependencies
}

func (h *disputeHandler) OpenDispute(orderID, reason, desc string, evidence []string) (*Dispute, error) {
	order, err := h.repo.GetByID(orderID)
	if err != nil {
		return nil, err
	}

	// Alibaba Rule: Can only dispute if order is Shipped/Delivered or Escrowed
	if order.Status == domain.StatusPendingPayment || order.Status == domain.StatusCompleted {
		return nil, errors.New("order state not eligible for dispute")
	}

	// 1. Lock funds further
	h.repo.UpdateStatus(orderID, domain.StatusDisputed)

	// 2. Create the dispute entry (This would go to a Dispute repo in a full impl)
	return &Dispute{
		ID:          "DISP-" + time.Now().Format("20060102150405"),
		OrderID:     orderID,
		Reason:      reason,
		Description: desc,
		Evidence:    evidence,
		Status:      DisputeStatusOpen,
		CreatedAt:   time.Now(),
	}, nil
}
