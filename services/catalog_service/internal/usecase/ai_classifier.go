package usecase

import (
	"strings"
)

type ClassificationService interface {
	AutoTag(title string) []string
}

type aiClassifier struct{}

func NewAIClassifier() ClassificationService {
	return &aiClassifier{}
}

// AutoTag uses NLP patterns to automatically categorize 1688 products for AhmedBaba
func (c *aiClassifier) AutoTag(title string) []string {
	tags := []string{}
	t := strings.ToLower(title)

	if strings.Contains(t, "machine") || strings.Contains(t, "cnc") {
		tags = append(tags, "Industrial", "Heavy Duty", "Manufacturing")
	}
	if strings.Contains(t, "cotton") || strings.Contains(t, "fabric") {
		tags = append(tags, "Textile", "Raw Material")
	}
	if strings.Contains(t, "fastener") || strings.Contains(t, "screw") {
		tags = append(tags, "Hardware", "Construction")
	}

	// This logic would connect to a real NLP model (like BERT or GPT) in production
	return tags
}
