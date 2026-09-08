package usecase

import (
	"log"
	"github.com/gorilla/websocket"
)

type StreamSession struct {
	SupplierID string
	Viewers    int
	IsActive   bool
}

type LiveStreamManager struct {
	activeStreams map[string]*StreamSession
}

func NewLiveStreamManager() *LiveStreamManager {
	return &LiveStreamManager{
		activeStreams: make(map[string]*StreamSession),
	}
}

// StartBroadcast initiates a "Live from Factory" session mirroring Alibaba Live
func (m *LiveStreamManager) StartBroadcast(supplierID string) {
	m.activeStreams[supplierID] = &StreamSession{
		SupplierID: supplierID,
		Viewers:    0,
		IsActive:   true,
	}
	log.Printf("[LIVE STREAM] Factory %s is now broadcasting live!", supplierID)
}

func (m *LiveStreamManager) HandleViewer(conn *websocket.Conn, supplierID string) {
	// Logic to pipe video buffer over websocket / WebRTC signaling
	if s, exists := m.activeStreams[supplierID]; exists {
		s.Viewers++
		log.Printf("[LIVE STREAM] New viewer joined factory tour %s. Total: %d", supplierID, s.Viewers)
	}
}
