package handlers

import (
	"github.com/ahmedbaba/ai-service/internal/infra/llm"
	"github.com/gin-gonic/gin"
	"net/http"
)

type AIHandler struct {
	llm *llm.LLMClient
}

func NewAIHandler(l *llm.LLMClient) *AIHandler {
	return &AIHandler{llm: l}
}

type TranslateRequest struct {
	Text       string `json:"text" binding:"required"`
	SourceLang string `json:"source_lang" binding:"required"`
	TargetLang string `json:"target_lang" binding:"required"`
}

func (h *AIHandler) Translate(c *gin.Context) {
	var req TranslateRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	translated, err := h.llm.TranslateText(c.Request.Context(), req.Text, req.SourceLang, req.TargetLang)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "AI Translation engine unavailable"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"translated_text": translated})
}

type SuggestRequest struct {
	ChatHistory string `json:"chat_history" binding:"required"`
}

func (h *AIHandler) SuggestNegotiation(c *gin.Context) {
	var req SuggestRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	suggestion, err := h.llm.GetNegotiationSuggestion(c.Request.Context(), req.ChatHistory)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "AI Suggestion engine unavailable"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"suggestion": suggestion})
}
