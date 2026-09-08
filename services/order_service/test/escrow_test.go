package test

import (
	"context"
	"github.com/ahmedbaba/order-service/internal/app/escrow"
	"github.com/ahmedbaba/order-service/internal/domain/entity"
	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
	"go.uber.org/zap"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
	"testing"
)

func setupTestDB() *gorm.DB {
	db, _ := gorm.Open(sqlite.Open(":memory:"), &gorm.Config{})
	db.AutoMigrate(&entity.Order{}, &entity.Transaction{})
	return db
}

func TestEscrowLifecycle(t *testing.T) {
	db := setupTestDB()
	logger, _ := zap.NewDevelopment()
	mgr := escrow.NewEscrowManager(db, logger)

	orderID := uuid.New()
	
	// 1. Create Mock Order
	order := entity.Order{
		ID:     orderID,
		Amount: 1000.00,
		Status: entity.StatusAwaitingPayment,
	}
	db.Create(&order)

	t.Run("Should transition from AwaitingPayment to InEscrow", func(t *testing.T) {
		err := mgr.TransitionToInEscrow(context.Background(), orderID.String())
		assert.NoError(t, err)

		var updatedOrder entity.Order
		db.First(&updatedOrder, "id = ?", orderID)
		assert.Equal(t, entity.StatusInEscrow, updatedOrder.Status)

		var tx entity.Transaction
		db.First(&tx, "order_id = ? AND type = ?", orderID, "DEPOSIT")
		assert.Equal(t, 1000.00, tx.Amount)
	})

	t.Run("Should fail to release funds if status is not Delivered", func(t *testing.T) {
		err := mgr.ReleaseFunds(context.Background(), orderID.String())
		assert.Error(t, err)
		assert.Contains(t, err.Error(), "shipping not confirmed")
	})

	t.Run("Should successfully release funds after delivery", func(t *testing.T) {
		db.Model(&entity.Order{}).Where("id = ?", orderID).Update("status", entity.StatusDelivered)
		
		err := mgr.ReleaseFunds(context.Background(), orderID.String())
		assert.NoError(t, err)

		var finalizedOrder entity.Order
		db.First(&finalizedOrder, "id = ?", orderID)
		assert.Equal(t, entity.StatusCompleted, finalizedOrder.Status)
	})
}
