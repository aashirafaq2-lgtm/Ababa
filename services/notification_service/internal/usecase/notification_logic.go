package usecase

import (
	"fmt"
	"log"
)

type NotificationType string

const (
	TypeOrderUpdate NotificationType = "ORDER_UPDATE"
	TypeNewBid      NotificationType = "NEW_BID"
	TypeChat        NotificationType = "CHAT_MESSAGE"
	TypeSecurity    NotificationType = "SECURITY_ALERT"
)

type NotificationService interface {
	SendPush(userID string, nType NotificationType, title, body string) error
	SendEmail(email string, subject, content string) error
}

type notificationHandler struct {
	fcmKey string // Firebase Cloud Messaging
}

func NewNotificationService(fcmKey string) NotificationService {
	return &notificationHandler{fcmKey: fcmKey}
}

func (h *notificationHandler) SendPush(userID string, nType NotificationType, title, body string) error {
	// In a real environment, this sends to Firebase/APNS
	log.Printf("[PUSH NOTIFICATION] To: %s | Type: %s | Title: %s", userID, nType, title)
	return nil
}

func (h *notificationHandler) SendEmail(email string, subject, content string) error {
	log.Printf("[EMAIL SENT] To: %s | Subject: %s", email, subject)
	return nil
}
