# ─── Stage 1: Builder ───────────────────────────────────────────────
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Install dependencies system (untuk CGO jika dibutuhkan)
RUN apk add --no-cache git ca-certificates tzdata

# Cache dependencies dulu sebelum copy source
COPY go.mod go.sum ./
RUN go mod download

# Copy source dan build
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -ldflags="-w -s" -o /blood-bank-api ./cmd/server/main.go

# ─── Stage 2: Runner ────────────────────────────────────────────────
FROM alpine:3.19

WORKDIR /app

# Sertakan CA certs dan timezone data
RUN apk --no-cache add ca-certificates tzdata

# Copy binary dari builder
COPY --from=builder /blood-bank-api .

# Expose port (sesuaikan dengan APP_PORT di .env)
EXPOSE 8080

# GCE / Cloud Run membaca PORT env variable — forward ke APP_PORT jika perlu
CMD ["./blood-bank-api"]