package logger

import (
	"encoding/json"
	"fmt"
	"time"
)

type LogLevel string

const (
	Info  LogLevel = "INFO"
	Error LogLevel = "ERROR"
	Fatal LogLevel = "FATAL"
)

type StructuredLog struct {
	Timestamp string   `json:"timestamp"`
	Level     LogLevel `json:"level"`
	Message   string   `json:"message"`
	ServiceID string   `json:"service_id"`
	TraceID   string   `json:"trace_id,omitempty"`
}

func Log(level LogLevel, serviceID, message, traceID string) {
	entry := StructuredLog{
		Timestamp: time.Now().Format(time.RFC3339),
		Level:     level,
		Message:   message,
		ServiceID: serviceID,
		TraceID:   traceID,
	}
	
	bytes, _ := json.Marshal(entry)
	fmt.Println(string(bytes))
}
