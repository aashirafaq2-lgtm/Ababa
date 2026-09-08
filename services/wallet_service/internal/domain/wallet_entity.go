package domain

import (
	"time"
)

type TransactionType string

const (
	TxDeposit TransactionType = "DEPOSIT"
	TxEscrow  TransactionType = "ESCROW_LOCK"
	TxRelease TransactionType = "FUND_RELEASE" // To Supplier
	TxRefund  TransactionType = "REFUND"
)

type Wallet struct {
	UserID    string    `gorm:"primaryKey"`
	Balance   float64   `gorm:"default:0"`
	Currency  string    `gorm:"default:'USD'"`
	UpdatedAt time.Time
}

type Transaction struct {
	ID        string          `gorm:"primaryKey"`
	WalletID  string          `gorm:"index"`
	Amount    float64
	Type      TransactionType
	OrderID   string
	RefID     string // External payment ref (Stripe ID)
	CreatedAt time.Time
}

type WalletRepository interface {
	GetByUserID(userID string) (*Wallet, error)
	CreateTransaction(tx *Transaction) error
	UpdateBalance(userID string, amount float64) error
}
