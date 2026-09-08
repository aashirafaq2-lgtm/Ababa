package middleware

import (
	"sync"
	"time"
)

type RateLimiter struct {
	ips map[string]time.Time
	mu  sync.Mutex
}

func NewRateLimiter() *RateLimiter {
	return &RateLimiter{ips: make(map[string]time.Time)}
}

// Allow checks if a request from a specific IP is allowed based on a 1-second cooldown
func (l *RateLimiter) Allow(ip string) bool {
	l.mu.Lock()
	defer l.mu.Unlock()
	
	last, exists := l.ips[ip]
	if exists && time.Since(last) < (500 * time.Millisecond) { // 2 requests per second limit
		return false
	}
	
	l.ips[ip] = time.Now()
	return true
}
