# Makefile for building the project

# Use /bin/bash as the shell
SHELL := /bin/bash

# Default target
.DEFAULT_GOAL := help

# Go application name
APP_NAME := echoserver-udp

# Help target
.PHONY: help
help: ## Show this help message
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

# Docker target
.PHONY: docker
docker: ## Build the Docker image
	@echo "Building Docker image..."
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--build-arg BUILD_DATE=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ") \
		--build-arg VCS_REF=$(shell git rev-parse --short HEAD) \
		--tag quay.io/cilium/$(APP_NAME) \
		.
	@echo "Docker image built: quay.io/cilium/$(APP_NAME)"

# Build target
.PHONY: build
build: ## Build the Go application
	@echo "Building the Go application..."
	go build \
		-ldflags="-s -w" \
		-a \
		-o $(APP_NAME) \
		main.go
	@echo "Build completed."

# Run target
.PHONY: run
run: ## Run the Go application
	@echo "Running the Go application..."
	./$(APP_NAME)

# Clean up build artifacts target
.PHONY: cleanup
cleanup: ## Clean up build artifacts
	@echo "Cleaning up build artifacts..."
	rm -f $(APP_NAME)
	@echo "Cleaning up build artifacts completed."