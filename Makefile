.PHONY: dev dev-build dev-down dev-rebuild prod prod-build prod-down logs logs-backend logs-frontend logs-db clean db-reset install-air help

# Development commands
dev:
	docker-compose -f docker-compose.dev.yml up

dev-build:
	docker-compose -f docker-compose.dev.yml build --no-cache
	docker-compose -f docker-compose.dev.yml up

dev-down:
	docker-compose -f docker-compose.dev.yml down

dev-rebuild:
	docker-compose -f docker-compose.dev.yml down -v
	docker-compose -f docker-compose.dev.yml build --no-cache
	docker-compose -f docker-compose.dev.yml up

# Production commands
prod:
	docker-compose up -d

prod-build:
	docker-compose build --no-cache
	docker-compose up -d

prod-down:
	docker-compose down

# Logs
logs:
	docker-compose logs -f

logs-backend:
	docker-compose logs -f backend

logs-frontend:
	docker-compose logs -f frontend

logs-db:
	docker-compose logs -f db

# Database commands
db-reset:
	docker-compose down -v
	docker-compose up -d db
	sleep 5

db-connect:
	docker-compose exec db psql -U postgres -d guitar_stock

# Backend commands
install-air:
	cd backend && go install github.com/cosmtrek/air@latest

backend-shell:
	docker-compose -f docker-compose.dev.yml exec backend sh

frontend-shell:
	docker-compose -f docker-compose.dev.yml exec frontend sh

# Clean up
clean:
	docker-compose down -v
	docker system prune -f

clean-all: clean
	docker-compose -f docker-compose.dev.yml down -v

# Help
help:
	@echo "Guitar Stock - Makefile Commands"
	@echo ""
	@echo "Development:"
	@echo "  make dev          - Start development environment with hot reload"
	@echo "  make dev-build    - Build and start dev environment"
	@echo "  make dev-down     - Stop development environment"
	@echo "  make dev-rebuild  - Clean rebuild of dev environment"
	@echo ""
	@echo "Production:"
	@echo "  make prod         - Start production environment"
	@echo "  make prod-build   - Build and start production"
	@echo "  make prod-down    - Stop production environment"
	@echo ""
	@echo "Logs:"
	@echo "  make logs         - View all logs"
	@echo "  make logs-backend - View backend logs"
	@echo "  make logs-frontend - View frontend logs"
	@echo "  make logs-db      - View database logs"
	@echo ""
	@echo "Database:"
	@echo "  make db-reset     - Reset database (deletes all data)"
	@echo "  make db-connect   - Connect to database"
	@echo ""
	@echo "Shell Access:"
	@echo "  make backend-shell  - Shell into backend container"
	@echo "  make frontend-shell - Shell into frontend container"
	@echo ""
	@echo "Cleanup:"
	@echo "  make clean        - Stop all containers and prune"
	@echo "  make clean-all    - Clean production and dev"
