.PHONY: run dev build test tidy 

run:
	go run ./cmd/server/main.go 

dev: 
	air 

build: 
	go build -o bin/blood-bank-api ./cmd/server/main.go 

test:
	go test ./.. 

tidy: 
	go mod tidy