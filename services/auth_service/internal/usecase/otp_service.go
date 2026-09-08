package usecase

import (
	"bytes"
	"encoding/json"
	"fmt"
	"math/rand"
	"net/http"
	"os"
	"time"
)

type OTPService struct {
	apiKey  string
	baseURL string
}

type OTPRequest struct {
	Phone   string `json:"phone"`
	Message string `json:"message"`
}

type OTPResponse struct {
	Success    bool   `json:"success"`
	RequestID  string `json:"requestId"`
	Message    string `json:"message"`
}

func NewOTPService() *OTPService {
	return &OTPService{
		apiKey:  os.Getenv("OTPIQ_API_KEY"),
		baseURL: os.Getenv("OTPIQ_BASE_URL"),
	}
}

// GenerateOTP creates a random 6-digit code
func (s *OTPService) GenerateOTP() string {
	rand.Seed(time.Now().UnixNano())
	return fmt.Sprintf("%06d", rand.Intn(999999))
}

// SendOTP sends the 6-digit code via OTPIQ (WhatsApp first, SMS fallback)
func (s *OTPService) SendOTP(phone string, code string) (*OTPResponse, error) {
	message := fmt.Sprintf("Your AhmedBaba verification code is: %s\nDo not share this code with anyone.\nValid for 5 minutes.", code)

	payload := OTPRequest{
		Phone:   phone,
		Message: message,
	}

	body, _ := json.Marshal(payload)

	req, err := http.NewRequest("POST", s.baseURL+"/send", bytes.NewBuffer(body))
	if err != nil {
		return nil, err
	}

	req.Header.Set("Authorization", "Bearer "+s.apiKey)
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{Timeout: 10 * time.Second}
	resp, err := client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("OTPIQ request failed: %v", err)
	}
	defer resp.Body.Close()

	var otpResp OTPResponse
	json.NewDecoder(resp.Body).Decode(&otpResp)

	return &otpResp, nil
}
