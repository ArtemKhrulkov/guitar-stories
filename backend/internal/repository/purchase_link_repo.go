package repository

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"

	"guitar-stock/internal/models"
)

const MaxLinksPerPlatform = 5

type PurchaseLinkRepository struct {
	db *gorm.DB
}

func (r *PurchaseLinkRepository) FindAll(limit int) ([]models.PurchaseLink, int64, error) {
	var links []models.PurchaseLink
	var total int64

	r.db.Model(&models.PurchaseLink{}).Count(&total)

	if limit > 0 {
		r.db.Limit(limit).Find(&links)
	} else {
		r.db.Find(&links)
	}

	return links, total, nil
}

func NewPurchaseLinkRepository(db *gorm.DB) *PurchaseLinkRepository {
	return &PurchaseLinkRepository{db: db}
}

func (r *PurchaseLinkRepository) FindByGuitarID(guitarID uuid.UUID) ([]models.PurchaseLink, error) {
	var links []models.PurchaseLink
	err := r.db.Where("guitar_id = ?", guitarID).Find(&links).Error
	return links, err
}

func (r *PurchaseLinkRepository) Create(link *models.PurchaseLink) error {
	return r.db.Create(link).Error
}

func (r *PurchaseLinkRepository) CreateIfNotExists(guitarID uuid.UUID, platform models.Platform, url string, priceRUB, priceUSD *float64, inStock bool) (*models.PurchaseLink, error) {
	var existing models.PurchaseLink
	err := r.db.Where("guitar_id = ? AND url = ?", guitarID, url).First(&existing).Error

	if err == gorm.ErrRecordNotFound {
		var count int64
		r.db.Model(&models.PurchaseLink{}).Where("guitar_id = ? AND platform = ?", guitarID, platform).Count(&count)
		if count >= MaxLinksPerPlatform {
			var oldest models.PurchaseLink
			r.db.Where("guitar_id = ? AND platform = ?", guitarID, platform).
				Order("COALESCE(last_scraped, created_at) ASC").First(&oldest)
			r.db.Delete(&oldest)
		}

		now := time.Now()
		link := &models.PurchaseLink{
			GuitarID:    guitarID,
			Platform:    platform,
			URL:         url,
			PriceRUB:    priceRUB,
			PriceUSD:    priceUSD,
			InStock:     inStock,
			LastScraped: &now,
		}
		return link, r.db.Create(link).Error
	}

	if err != nil {
		return nil, err
	}

	existing.PriceRUB = priceRUB
	existing.PriceUSD = priceUSD
	existing.InStock = inStock
	now := time.Now()
	existing.LastScraped = &now
	return &existing, r.db.Save(&existing).Error
}

func (r *PurchaseLinkRepository) DeleteByGuitarID(guitarID uuid.UUID) error {
	return r.db.Delete(&models.PurchaseLink{}, "guitar_id = ?", guitarID).Error
}

func (r *PurchaseLinkRepository) DeleteByID(id uuid.UUID) error {
	return r.db.Delete(&models.PurchaseLink{}, "id = ?", id).Error
}
