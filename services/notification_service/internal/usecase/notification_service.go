package usecase

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"time"
)

type NotificationService struct {
	appID   string
	restKey string
}

type NotificationPayload struct {
	AppID    string            `json:"app_id"`
	Headings map[string]string `json:"headings"`
	Contents map[string]string `json:"contents"`
	Filters  []interface{}     `json:"filters,omitempty"`
	PlayerID []string          `json:"include_player_ids,omitempty"`
}

func NewNotificationService() *NotificationService {
	return &NotificationService{
		appID:   os.Getenv("ONESIGNAL_APP_ID"),
		restKey: os.Getenv("ONESIGNAL_REST_API_KEY"),
	}
}

// SendToUser sends a push notification to a specific user device
func (n *NotificationService) SendToUser(playerID, title, message string) error {
	payload := NotificationPayload{
		AppID:    n.appID,
		Headings: map[string]string{"en": title, "ar": title},
		Contents: map[string]string{"en": message, "ar": message},
		PlayerID: []string{playerID},
	}
	return n.send(payload)
}

// SendOrderUpdate notifies buyer when their order status changes
func (n *NotificationService) SendOrderUpdate(playerID, orderID, status string) error {
	title := "Order Update — AhmedBaba"
	message := fmt.Sprintf("Your order #%s is now: %s", orderID, status)
	return n.SendToUser(playerID, title, message)
}

// SendShipmentAlert notifies buyer when shipment departs
func (n *NotificationService) SendShipmentAlert(playerID, origin, destination string) error {
	title := "Shipment Departed"
	message := fmt.Sprintf("Your cargo has left %s and is heading to %s", origin, destination)
	return n.SendToUser(playerID, title, message)
}

// SendNewRFQReply notifies supplier when buyer replies to an RFQ
func (n *NotificationService) SendNewRFQReply(playerID, buyerName string) error {
	title := "New RFQ Reply"
	message := fmt.Sprintf("%s has responded to your quotation", buyerName)
	return n.SendToUser(playerID, title, message)
}

func (n *NotificationService) send(payload NotificationPayload) error {
	body, _ := json.Marshal(payload)
	req, _ := http.NewRequest("POST", "https://onesignal.com/api/v1/notifications", bytes.NewBuffer(body))
	req.Header.Set("Authorization", "Basic "+n.restKey)
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{Timeout: 10 * time.Second}
	resp, err := client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		return fmt.Errorf("OneSignal error: %s", resp.Status)
	}
	return nil
}
