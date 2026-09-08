package usecase

import (
	"crypto/rand"
	"encoding/hex"
	"time"
)

type TokenStore struct {
	tokens map[string]string // userID -> RefreshToken
}

type IdentityManager struct {
	store *TokenStore
}

func NewIdentityManager() *IdentityManager {
	return &IdentityManager{
		store: &TokenStore{tokens: make(map[string]string)},
	}
}

// GenerateSession returns an AccessToken and a long-lived RefreshToken
func (m *IdentityManager) GenerateSession(userID string) (string, string) {
	accessToken := "AT-" + hex.EncodeToString(m.pseudoRandom(16))
	refreshToken := "RT-" + hex.EncodeToString(m.pseudoRandom(32))
	
	m.store.tokens[userID] = refreshToken
	return accessToken, refreshToken
}

func (m *IdentityManager) RefreshSession(userID, oldRefreshToken string) (string, error) {
	if m.store.tokens[userID] == oldRefreshToken {
		newAT, _ := m.GenerateSession(userID)
		return newAT, nil
	}
	return "", fmt.Errorf("invalid refresh token")
}

func (m *IdentityManager) pseudoRandom(n int) []byte {
	b := make([]byte, n)
	rand.Read(b)
	return b
}
