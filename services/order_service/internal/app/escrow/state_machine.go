package escrow

import (
	"context"
	"errors"
	"github.com/ahmedbaba/order-service/internal/domain/entity"
	"go.uber.org/zap"
	"gorm.io/gorm"
)

type EscrowManager struct {
	db     *gorm.DB
	logger *zap.Logger
}

func NewEscrowManager(db *gorm.DB, logger *zap.Logger) *EscrowManager {
	return &EscrowManager{db: db, logger: logger}
}

// TransitionToInEscrow handles the fund locking event
func (m *EscrowManager) TransitionToInEscrow(ctx context.Context, orderID string) error {
	return m.db.Transaction(func(tx *gorm.DB) error {
		var order entity.Order
		if err := tx.First(&order, "id = ?", orderID).Error; err != nil {
			return err
		}

		if order.Status != entity.StatusAwaitingPayment {
			return errors.New("invalid state for escrow lock")
		}

		// Atomic Update to IN_ESCROW
		order.Status = entity.StatusInEscrow
		if err := tx.Save(&order).Error; err != nil {
			return err
		}

		// Log Financial Transaction (ACID compliant)
		transaction := entity.Transaction{
			OrderID: order.ID,
			Amount:  order.Amount,
			Type:    "DEPOSIT",
			LedgerEntry: "Funds locked in AhmedBaba Global Escrow",
		}
		
		return tx.Create(&transaction).Error
	})
}

// ReleaseFunds releases locked money to the supplier upon delivery confirmation
func (m *EscrowManager) ReleaseFunds(ctx context.Context, orderID string) error {
	return m.db.Transaction(func(tx *gorm.DB) error {
		var order entity.Order
		if err := tx.First(&order, "id = ?", orderID).Error; err != nil {
			return err
		}

		if order.Status != entity.StatusDelivered {
			return errors.New("cannot release funds: shipping not confirmed as delivered")
		}

		order.Status = entity.StatusCompleted
		if err := tx.Save(&order).Error; err != nil {
			return err
		}

		// Payout Ledger Entry
		transaction := entity.Transaction{
			OrderID: order.ID,
			Amount:  order.Amount,
			Type:    "RELEASE",
			LedgerEntry: "Escrow funds released to Supplier payout wallet",
		}

		return tx.Create(&transaction).Error
	})
}
