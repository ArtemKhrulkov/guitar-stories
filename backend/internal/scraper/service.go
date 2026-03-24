package scraper

import (
	"log"

	"github.com/google/uuid"
	"gorm.io/gorm"

	"guitar-stock/internal/models"
	"guitar-stock/internal/repository"
)

type Service struct {
	db               *gorm.DB
	guitarRepo       *repository.GuitarRepository
	brandRepo        *repository.BrandRepository
	purchaseLinkRepo *repository.PurchaseLinkRepository
	priceHistoryRepo *repository.PriceHistoryRepository
}

func NewService(db *gorm.DB) *Service {
	return &Service{
		db:               db,
		guitarRepo:       repository.NewGuitarRepository(db),
		brandRepo:        repository.NewBrandRepository(db),
		purchaseLinkRepo: repository.NewPurchaseLinkRepository(db),
		priceHistoryRepo: repository.NewPriceHistoryRepository(db),
	}
}

func NewServiceWithRepos(db *gorm.DB, guitarRepo *repository.GuitarRepository, brandRepo *repository.BrandRepository, purchaseLinkRepo *repository.PurchaseLinkRepository, priceHistoryRepo *repository.PriceHistoryRepository) *Service {
	return &Service{
		db:               db,
		guitarRepo:       guitarRepo,
		brandRepo:        brandRepo,
		purchaseLinkRepo: purchaseLinkRepo,
		priceHistoryRepo: priceHistoryRepo,
	}
}

func (s *Service) ScrapeGuitar(guitarID uuid.UUID) ([]models.PurchaseLink, error) {
	brand, err := s.guitarRepo.GetBrand(guitarID)
	if err != nil {
		return nil, err
	}

	guitar, err := s.guitarRepo.FindByID(guitarID)
	if err != nil {
		return nil, err
	}

	log.Printf("[SCRAPER] Starting scrape for guitar: %s (%s %s)", guitar.Model, brand.Name, guitarID)

	platforms := []Platform{Ozon, Wildberries}
	var allLinks []models.PurchaseLink

	for _, platform := range platforms {
		log.Printf("[SCRAPER] Scraping platform: %s", platform)
		scraper := NewScraper(platform)
		results, err := scraper.Search(brand.Name, guitar.Model)
		if err != nil {
			log.Printf("[SCRAPER] Error from %s: %v", platform, err)
			continue
		}
		log.Printf("[SCRAPER] Found %d results from %s", len(results), platform)

		for _, result := range results {
			link, err := s.purchaseLinkRepo.CreateIfNotExists(
				guitarID,
				models.Platform(platform),
				result.URL,
				result.PriceRUB,
				result.PriceUSD,
				result.InStock,
			)
			if err == nil && link != nil {
				log.Printf("[SCRAPER] Created link: %s - %s", platform, result.URL)
				history := &models.PriceHistory{
					PurchaseLinkID: link.ID,
					PriceRUB:       link.PriceRUB,
					PriceUSD:       link.PriceUSD,
				}
				s.priceHistoryRepo.Create(history)

				allLinks = append(allLinks, *link)
			}
		}
	}

	log.Printf("[SCRAPER] Completed scrape for %s, found %d total links", guitar.Model, len(allLinks))
	return allLinks, nil
}

func (s *Service) ScrapeAll() error {
	ids, err := s.guitarRepo.FindAllIDs()
	if err != nil {
		return err
	}

	for _, id := range ids {
		go func(guitarID uuid.UUID) {
			s.ScrapeGuitar(guitarID)
		}(id)
	}

	return nil
}

func (s *Service) StartScheduler() {
	// Scheduler implementation will be added here
	// Using robfig/cron for periodic scraping
}
