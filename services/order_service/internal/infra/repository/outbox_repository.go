package repository

import (
	"database/sql"
	"fmt"
)

type OutboxEvent struct {
	ID        int
	Payload   string
	Status    string // PENDING, PROCESSED
}

type OrderRepository struct {
	db *sql.DB
}

// CreateOrderWithOutbox performs an atomic transaction for B2B order creation
func (r *OrderRepository) CreateOrderWithOutbox(orderID string, payload string) error {
	tx, err := r.db.Begin()
	if err != nil {
		return err
	}
	defer tx.Rollback()

	// 1. Create the Order
	_, err = tx.Exec("INSERT INTO orders (id, status) VALUES (?, ?)", orderID, "CREATED")
	if err != nil {
		return fmt.Errorf("order insert failed: %v", err)
	}

	// 2. Create the Outbox Event for Notification/Wallet service
	_, err = tx.Exec("INSERT INTO outbox (payload, status) VALUES (?, ?)", payload, "PENDING")
	if err != nil {
		return fmt.Errorf("outbox insert failed: %v", err)
	}

	return tx.Commit()
}
