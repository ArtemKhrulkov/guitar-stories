# Guitar Stock Application

## Overview
A web application for guitar enthusiasts to browse guitar catalogs, explore detailed descriptions, view famous players, and find purchase links from various e-commerce platforms.

## Tech Stack

### Frontend
- **Framework**: Nuxt 3 (Vue 3 SSR)
- **Styling**: TailwindCSS + Vuetify
- **State Management**: Pinia (Nuxt built-in)
- **HTTP Client**: $fetch (Nuxt built-in)

### Backend
- **Language**: Go 1.21+
- **Framework**: Gin
- **Architecture**: Clean Architecture (single module)
- **ORM/Query Builder**: GORM

### Database
- **Type**: PostgreSQL 15
- **Migrations**: SQL files in `/migrations`

### Scraping
- **Libraries**: colly (simple pages) + chromedp (JavaScript-rendered)
- **Targets**: Ozon, Wildberries

### Deployment
- **Type**: Docker Compose (local development)
- **Services**: backend, frontend, postgres

---

## Project Structure

```
guitar-stock-app/
├── backend/                      # Go application
│   ├── cmd/
│   │   ├── server/           # API server entry point
│   │   │   └── main.go
│   │   └── scraper/          # Image scraper CLI
│   │       └── main.go
│   ├── internal/
│   │   ├── config/            # Environment configuration
│   │   │   └── config.go
│   │   ├── database/          # Database connection
│   │   │   └── postgres.go
│   │   ├── handlers/          # HTTP handlers
│   │   │   ├── brand.go
│   │   │   ├── guitar.go
│   │   │   ├── player.go
│   │   │   └── scraper.go
│   │   ├── models/            # Database models
│   │   │   ├── brand.go
│   │   │   ├── guitar.go
│   │   │   ├── player.go
│   │   │   ├── guitar_player.go
│   │   │   └── purchase_link.go
│   │   ├── repository/        # Data access layer
│   │   │   ├── brand_repo.go
│   │   │   ├── guitar_repo.go
│   │   │   └── player_repo.go
│   │   ├── services/         # Business logic
│   │   │   ├── guitar_service.go
│   │   │   └── scraper_service.go
│   │   ├── router/           # Route definitions
│   │   │   └── router.go
│   │   └── scraper/          # Scraper services
│   │       ├── images/       # Image scraper
│   │       │   ├── browser.go
│   │       │   ├── scraper_wrapper.go
│   │       │   ├── wildberries.go
│   │       │   ├── sweetwater.go
│   │       │   ├── manufacturer.go
│   │       │   ├── guitarcenter.go
│   │       │   ├── bing.go
│   │       │   └── google.go
│   │       ├── ozon.go
│   │       ├── wildberries.go
│   │       └── factory.go
│   ├── migrations/           # SQL schema
│   │   ├── 001_init.sql
│   │   └── 002_seed.sql
│   ├── go.mod
│   └── go.sum
├── frontend/                 # Nuxt 3 application
│   ├── nuxt.config.ts
│   ├── app.vue
│   ├── pages/
│   │   ├── index.vue         # Home/catalog page
│   │   ├── guitars/
│   │   │   ├── index.vue     # Catalog with filters
│   │   │   └── [id].vue      # Guitar detail page
│   │   └── brands/
│   │       ├── index.vue     # Brand directory
│   │       └── [id].vue      # Brand detail page
│   ├── components/
│   │   ├── GuitarCard.vue
│   │   ├── GuitarFilters.vue
│   │   ├── PlayerBadge.vue
│   │   ├── PurchaseLinks.vue
│   │   └── BrandHeader.vue
│   ├── composables/
│   │   ├── useGuitars.ts
│   │   ├── useBrands.ts
│   │   └── useSearch.ts
│   ├── layouts/
│   │   ├── default.vue
│   │   └── guitar-layout.vue
│   └── assets/
│       └── css/
│           └── main.css
├── docker-compose.yml
├── .env.example
└── README.md
```

---

## Database Schema

### brands
| Column | Type | Constraints |
|--------|------|-------------|
| id | UUID | PRIMARY KEY |
| name | VARCHAR(255) | NOT NULL, UNIQUE |
| country | VARCHAR(100) | NOT NULL |
| founded_year | INTEGER | |
| description | TEXT | |
| logo_url | VARCHAR(500) | |
| created_at | TIMESTAMP | DEFAULT NOW() |
| updated_at | TIMESTAMP | DEFAULT NOW() |

### guitars
| Column | Type | Constraints |
|--------|------|-------------|
| id | UUID | PRIMARY KEY |
| brand_id | UUID | FK → brands.id |
| model | VARCHAR(255) | NOT NULL |
| guitar_type | ENUM | electric, acoustic, bass |
| price_range | VARCHAR(100) | e.g., "1 000 - 1 500 USD / 100 000 - 150 000 RUB" |
| specifications | JSONB | {body_wood, neck_wood, pickup_config, frets, scale_length, hardware} |
| history | TEXT | Detailed history, famous players, cultural impact |
| image_url | VARCHAR(500) | Manufacturer URL |
| created_at | TIMESTAMP | DEFAULT NOW() |
| updated_at | TIMESTAMP | DEFAULT NOW() |

### players
| Column | Type | Constraints |
|--------|------|-------------|
| id | UUID | PRIMARY KEY |
| name | VARCHAR(255) | NOT NULL |
| genre | VARCHAR(100) | e.g., Rock, Jazz, Metal |
| bio | TEXT | |
| image_url | VARCHAR(500) | |
| created_at | TIMESTAMP | DEFAULT NOW() |
| updated_at | TIMESTAMP | DEFAULT NOW() |

### guitar_players (Junction Table)
| Column | Type | Constraints |
|--------|------|-------------|
| guitar_id | UUID | FK → guitars.id |
| player_id | UUID | FK → players.id |
| note | TEXT | e.g., "Famous for using this model in 1975 tour" |
| PRIMARY KEY | (guitar_id, player_id) | |

### purchase_links
| Column | Type | Constraints |
|--------|------|-------------|
| id | UUID | PRIMARY KEY |
| guitar_id | UUID | FK → guitars.id |
| platform | ENUM | ozon, wildberries, sweetwater, guitarcenter |
| url | VARCHAR(500) | NOT NULL |
| price_rub | DECIMAL(10,2) | Nullable |
| price_usd | DECIMAL(10,2) | Nullable |
| in_stock | BOOLEAN | DEFAULT true |
| last_scraped | TIMESTAMP | |
| created_at | TIMESTAMP | DEFAULT NOW() |
| updated_at | TIMESTAMP | DEFAULT NOW() |

---

## API Endpoints

### Brands
- `GET /api/brands` - List all brands
  - Response: `{ brands: Brand[] }`
- `GET /api/brands/:id` - Get brand with guitars
  - Response: `{ brand: Brand, guitars: Guitar[] }`

### Guitars
- `GET /api/guitars` - List guitars with filters
  - Query params: 
    - `brand` (UUID[]): Filter by brands (supports multiple, e.g., `?brand=id1&brand=id2`)
    - `type` (string): electric|acoustic|bass
    - `min_price` (float): Price range min (RUB)
    - `max_price` (float): Price range max (RUB)
    - `in_stock` (bool): Filter by availability
    - `sort` (string): newest|model (default: newest)
    - `dir` (string): asc|desc (default: desc)
    - `search` (string): Full-text search in model/history
    - `page` (int): Pagination (default: 1)
    - `limit` (int): Items per page (default: 12)
  - Response: `{ guitars: Guitar[], total: int, page: int, limit: int }`
- `GET /api/guitars/:id` - Get guitar detail
  - Response: `{ guitar: Guitar, players: Player[], purchase_links: Link[] }`

### Players
- `GET /api/players` - List all players
  - Response: `{ players: Player[] }`
- `GET /api/players/:id` - Get player with guitars
  - Response: `{ player: Player, guitars: Guitar[] }`

### Search
- `GET /api/search?q=...` - Full-text search
  - Response: `{ guitars: Guitar[], players: Player[] }`

### Admin/Scraper
- `POST /api/admin/scrape/:guitar_id` - Trigger scrape for specific guitar
  - Response: `{ links: PurchaseLink[] }`
- `POST /api/admin/scrape/all` - Trigger scrape for all guitars
  - Response: `{ message: string }`

---

## Specifications JSON Structure

```json
{
  "body_wood": "Mahogany",
  "neck_wood": "Maple",
  "fretboard": "Rosewood",
  "pickup_config": "HH (Humbucker-Humbucker)",
  "frets": 22,
  "scale_length": "24.75\"",
  "hardware": "Chrome TOM Bridge",
  "bridge": "Tune-o-Matic",
  "tuners": "Grover Rotomatics"
}
```

---

## Price Range Format

String format with space-separated thousands:
- `"1 000 - 1 500 USD / 100 000 - 150 000 RUB"`
- Both USD and RUB ranges included
- Space separator for readability (not comma)

---

## Initial Brands & Sample Guitars

### 1. Gibson (USA)
- Les Paul Standard, SG, Explorer, Firebird, ES-335

### 2. Fender (USA)
- Stratocaster, Telecaster, Jazzmaster, Jaguar, Mustang

### 3. Ibanez (Japan)
- JEM777, RG550, Artcore, AZ series

### 4. ESP (Japan)
- Horizon, M-II, EC-256, LTD series

### 5. Schecter (USA)
- Solo-II, C-1, Damien, Omen

### 6. Yamaha (Japan)
- Pacifica, Revstar, FG series, SLG series

### 7. Music Man (USA)
- StingRay, Axis, Silhouette, Bongo

### 8. Greco (Japan)
- EG-800, Genesis series, J-GR series

### 9. Burny (Japan)
- RLG-85, FLG-85, Les Paul custom

### 10. Squier (Japan)
- Stratocaster, Telecaster, Bass, Jagmaster

### 11. Gretsch (USA)
- G5420, White Falcon, Penguine, Electromatic

### 12. Sterling by Music Man (Japan)
- Silhouette, Axis, Cutlass, StingRay bass

---

## Scraper Architecture

### Platform Support
- **Ozon**: ozon.ru
- **Wildberries**: wildberries.ru

### Implementation
- Use factory pattern for platform selection
- colly for static pages
- go-rod for JavaScript-rendered pages

### Search Query Format
```
"{Brand} {Model} guitar"
Example: "Gibson Les Paul Standard guitar"
```

### Data Extracted
- Product title
- Price (RUB/USD)
- Stock status
- Product URL

### Update Schedule
- Background cron: every 24 hours
- Manual trigger: `/api/admin/scrape/:guitar_id`

### Error Handling
- Retry 3 times with exponential backoff
- Fallback to manual links if scraping fails
- Log all failures for review

---

## Image Scraper CLI

The image scraper runs as a **standalone CLI tool** outside of Docker for better performance.

### Why Outside Docker?
- Browser automation is slow in Docker containers (30-60s per request)
- Native Chrome on host machine is much faster
- Avoids Docker-specific browser configuration issues

### Installation

**macOS:**
```bash
brew install --cask google-chrome
```

**Linux (Ubuntu/Debian):**
```bash
apt install chromium chromium-driver
# or
apt install chromium-browser
```

**Linux (RHEL/Fedora):**
```bash
dnf install chromium
```

**Windows:**
Download from https://www.google.com/chrome/

### Usage

```bash
# Check if Chrome is installed
go run ./backend/cmd/scraper/main.go --check

# Scrape all guitars without images
go run ./backend/cmd/scraper/main.go --all

# Scrape specific guitar
go run ./backend/cmd/scraper/main.go --guitar-id <uuid>

# Higher concurrency for faster scraping
go run ./backend/cmd/scraper/main.go --all --concurrency 4 --batch-size 5

# Use with Docker database
DATABASE_URL="postgres://postgres:postgres@localhost:5432/guitar_stock" \
  go run ./backend/cmd/scraper/main.go --all
```

### Flags
| Flag | Default | Description |
|------|---------|-------------|
| `--all` | - | Scrape all guitars without images |
| `--guitar-id` | - | Scrape specific guitar by UUID |
| `--batch-size` | 3 | Number of guitars per batch |
| `--concurrency` | 2 | Number of concurrent scrapers |
| `--check` | - | Check Chrome installation |
| `--v` | - | Verbose output |

### Environment Variables
| Variable | Default | Description |
|----------|---------|-------------|
| `DATABASE_URL` | postgres://postgres:postgres@localhost:5432/guitar_stock | PostgreSQL connection string |
| `CHROME_PATH` | auto-detect | Path to Chrome binary |
| `PROXY_URLS` | - | Proxy URLs for scraping |

### Image Sources (in priority order)
1. **Bing Images** - Browser automation (fastest, most reliable)
2. **Google Images** - Browser automation
3. **Sweetwater** - HTTP requests (may return 403)
4. **Manufacturer** - HTTP requests + browser fallback (12 brands, can be slow)
5. **GuitarCenter** - HTTP requests + browser fallback (may return ads)
6. **Wildberries** - Browser automation (blocked by anti-bot in some regions)

**Note:** Wildberries requires proxy support and may be blocked by anti-bot protection. Bing Images is the most reliable source and is tried first.

### Build Binary
```bash
cd backend
go build -o bin/image-scraper ./cmd/scraper
./bin/image-scraper --all
```

### Production Deployment
On your production server:
1. Install Chrome
2. Copy the `image-scraper` binary
3. Set up a cron job or systemd service:
```bash
# Cron example (daily at 3 AM)
0 3 * * * /opt/guitar-stock/image-scraper --all >> /var/log/image-scraper.log 2>&1
```

---

## Frontend Components

### GuitarCard.vue
- Displays: image, brand, model, price range, type badge
- Hover effects and responsive grid
- Links to detail page

### GuitarFilters.vue
- Sidebar with collapsible sections
- Brand checkboxes
- Guitar type radio buttons
- Price range slider
- Clear all filters button

### PlayerBadge.vue
- Small chip with player image and name
- Links to player detail page
- Tooltip with player genre

### PurchaseLinks.vue
- List of purchase links grouped by platform
- Shows price and stock status
- External links open in new tab
- Last scraped timestamp

### BrandHeader.vue
- Brand logo
- Country and founding year
- Description
- Link to brand page

---

## Environment Variables

### Backend (.env)
```
PORT=8080
DATABASE_URL=postgres://user:password@localhost:5432/guitar_stock
GIN_MODE=debug
ALLOWED_ORIGINS=http://localhost:3000
```

### Frontend (.env)
```
NUXT_PUBLIC_API_URL=http://localhost:8080/api
```

---

## Docker Configuration

### Services
1. **backend**: Go application on port 8080
2. **frontend**: Nuxt 3 SSR on port 3000
3. **postgres**: Database on port 5432

### Volumes
- `pgdata`: Persistent PostgreSQL data

### Ports
- Frontend: 3000
- Backend: 8080
- PostgreSQL: 5432

---

## Makefile Commands

A Makefile in the project root provides convenient shortcuts for common development tasks:

### Development
```bash
make dev           # Start development environment with hot reload
make dev-build    # Build and start dev environment
make dev-down     # Stop development environment
make dev-rebuild  # Clean rebuild of dev environment
```

### Production
```bash
make prod         # Start production environment
make prod-build   # Build and start production
make prod-down    # Stop production environment
```

### Logs
```bash
make logs          # View all logs
make logs-backend  # View backend logs
make logs-frontend # View frontend logs
make logs-db       # View database logs
```

### Database
```bash
make db-reset    # Reset database (deletes all data)
make db-connect  # Connect to database via psql
```

### Shell Access
```bash
make backend-shell   # Shell into backend container
make frontend-shell  # Shell into frontend container
```

### Cleanup
```bash
make clean      # Stop all containers and prune
make clean-all  # Clean production and dev
```

---

## Implementation Phases

### Phase 1: Backend Foundation
1. Initialize Go module
2. Set up PostgreSQL with migrations
3. Create models and database connection
4. Implement Gin router
5. Build repository layer

### Phase 2: API & Services
1. Implement all REST endpoints
2. Add search and filter logic
3. Create scraper service
4. Build Ozon scraper
5. Build Wildberries scraper

### Phase 3: Data Seeding
1. Create seed script
2. Populate 12 brands
3. Add ~5-10 guitars per brand
4. Include famous players
5. Add manual purchase links

### Phase 4: Frontend Foundation
1. Initialize Nuxt 3 project
2. Configure TailwindCSS
3. Integrate Vuetify
4. Set up layouts
5. Create composables

### Phase 5: Frontend Features
1. Build guitar catalog page
2. Implement filter sidebar
3. Create detail page
4. Add player associations
5. Build purchase links section

### Phase 6: Brand Pages
1. Create brand directory page
2. Build brand detail page
3. Link brands to guitars

### Phase 7: Polish & Deploy
1. Set up Docker Compose
2. Add error handling
3. Create loading states
4. Test responsiveness
5. Performance optimization

---

## Code Style Guidelines

### Go
- Use `internal/` for private packages
- Repository pattern for data access
- Service layer for business logic
- Handler layer for HTTP
- Return structured JSON responses
- Proper error handling with context

### Vue/TypeScript
- Composition API with `<script setup>`
- TypeScript for all components
- Composables for reusable logic
- Vuetify components where appropriate
- TailwindCSS for custom styling
- Proper TypeScript types

---

## Testing Strategy

### Backend
- Unit tests for services
- Integration tests for handlers
- Repository tests with test database

### Frontend
- Component tests with Vitest
- E2E tests with Playwright
- Type checking with vue-tsc

---

## Performance Considerations

### Backend
- Database indexes on frequently queried columns
- Pagination for list endpoints
- Caching for brand list (can be added later)

### Frontend
- Image lazy loading
- SSR for SEO
- Proper meta tags for sharing
- Responsive images

---

## Future Enhancements

### Priority: High
- ~~Advanced search with filters~~ ✅ Implemented
- ~~Admin panel for CRUD operations~~ ✅ Implemented

### Priority: Medium
- SEO optimization (sitemap, structured data, meta tags)
- Price history tracking
- Wishlist functionality

### Priority: Low
- User authentication
- User reviews
- Performance optimization (lazy loading, caching)

### Completed
- ~~Comparison tool~~ ✅ Implemented
- Dark/light theme toggle (basic dark theme active)

---

## Comparison Tool

### Overview
Side-by-side guitar comparison with up to 4 guitars, highlighting differences in specifications.

### Features
- Select up to 4 guitars from catalog using toggle button on cards
- Floating bar shows selected guitars at bottom of page
- Dedicated `/compare` page with full comparison table
- Highlights rows where specs differ (yellow background)
- Persists selection in localStorage
- Sections: General, Electronics, Playability, Hardware

### Files
```
frontend/
├── stores/
│   └── comparison.ts        # Pinia store, max 4 guitars, localStorage persistence
├── composables/
│   └── useComparison.ts     # Fetch guitars, compute differences
├── components/
│   └── comparison/
│       ├── Bar.vue          # Floating selection bar at bottom
│       ├── Chip.vue         # Removable guitar chip
│       └── Table.vue        # Side-by-side comparison table
├── pages/
│   └── compare.vue          # Main comparison page
```

### API
Uses existing `/api/guitars/:id` endpoint - no backend changes needed.
