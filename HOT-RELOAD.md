# Development Setup - Hot Reload

## Quick Start

### Development Environment (with hot reload)
```bash
make dev-build    # Build and start dev environment
# or
make dev          # Start dev environment (if already built)
```

### Production Environment
```bash
make prod-build   # Build and start production
# or
make prod         # Start production (if already built)
```

## Available Commands

### Development Commands
```bash
make dev          - Start development environment with hot reload
make dev-build   - Build and start dev environment
make dev-down    - Stop development environment
make dev-rebuild - Clean rebuild of dev environment
```

### Production Commands
```bash
make prod         - Start production environment
make prod-build  - Build and start production
make prod-down   - Stop production environment
```

### Logs
```bash
make logs          - View all logs
make logs-backend  - View backend logs
make logs-frontend - View frontend logs
make logs-db      - View database logs
```

### Database
```bash
make db-reset     - Reset database (deletes all data)
make db-connect   - Connect to database shell
```

### Shell Access
```bash
make backend-shell   - Shell into backend container
make frontend-shell - Shell into frontend container
```

### Cleanup
```bash
make clean         - Stop all containers and prune Docker
make clean-all    - Clean production and dev environments
```

## Services

### Development Environment
- **Backend**: http://localhost:8080 (Go + Gin with hot reload via air)
- **Frontend**: http://localhost:3000 (Nuxt with hot reload)
- **Database**: PostgreSQL on localhost:5432

### Production Environment
- **Backend**: http://localhost:8080 (Go + Gin)
- **Frontend**: http://localhost:3000 (Nuxt SSR)
- **Database**: PostgreSQL on localhost:5432

## Hot Reload Features

### Backend (Go)
- **air** watches for file changes in `./backend` directory
- Automatically rebuilds and restarts on `.go` file changes
- Logs rebuild status to container logs

### Frontend (Nuxt)
- **Vite HMR** (Hot Module Replacement)
- Instant updates without full page reload
- Accessible on port 24678 for debugging

## File Changes

Files mounted as volumes:
```yaml
backend:
  - ./backend:/app          # Source code
  - backend_go_cache:/go/pkg  # Go modules cache

frontend:
  - ./frontend:/app              # Source code
  - frontend_node_modules:/app/node_modules  # npm packages
```

## Troubleshooting

### Backend not reloading?
Check logs: `make logs-backend`

### Frontend not updating?
1. Check `make logs-frontend`
2. Ensure volume mounts are working
3. Try restarting: `make dev-down && make dev`

### Database connection issues?
```bash
make db-reset
```

### Clean everything and start fresh?
```bash
make clean-all
make dev-build
```

## Environment Variables

Development uses:
```
GIN_MODE=debug
PORT=8080
NUXT_PUBLIC_API_URL=http://localhost:8080/api
```

Production uses:
```
GIN_MODE=release
NUXT_PUBLIC_API_URL=http://backend:8080/api
```
