# Stage 1: Builder
FROM golang:1.21-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /auth-service ./cmd/server/main.go

# Stage 2: Runner
FROM alpine:latest

WORKDIR /

COPY --from=builder /auth-service /auth-service
COPY internal/config/config.yaml /internal/config/config.yaml

EXPOSE 8080 50051

ENTRYPOINT ["/auth-service"]
