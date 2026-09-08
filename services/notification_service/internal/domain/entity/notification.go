package entity

import "time"

type NotificationType string

const (
	TypePush  NotificationType = "PUSH"
	TypeEmail NotificationType = "EMAIL"
	TypeSMS   NotificationType = "SMS"
)

type Notification struct {
	ID        string           `json:"id"`
	UserID    string           `json:"user_id"`
	Type      NotificationType `json:"type"`
	Title     string           `json:"title"`
	Content   string           `json:"content"`
	Status    string           `json:"status"` // SENT, FAILED, PENDING
	CreatedAt time.Time        `json:"created_at"`
}
