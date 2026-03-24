package repository

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"

	"guitar-stock/internal/models"
)

type PriceHistoryRepository struct {
	db *gorm.DB
}

func NewPriceHistoryRepository(db *gorm.DB) *PriceHistoryRepository {
	return &PriceHistoryRepository{db: db}
}

func (r *PriceHistoryRepository) Create(history *models.PriceHistory) error {
	return r.db.Create(history).Error
}

func (r *PriceHistoryRepository) FindByPurchaseLinkID(linkID uuid.UUID, limit int) ([]models.PriceHistory, error) {
	var history []models.PriceHistory
	err := r.db.Where("purchase_link_id = ?", linkID).
		Order("recorded_at DESC").
		Limit(limit).
		Find(&history).Error
	return history, err
}

func (r *PriceHistoryRepository) DeleteOlderThan(days int) error {
	cutoff := time.Now().AddDate(0, 0, -days)
	return r.db.Delete(&models.PriceHistory{}, "recorded_at < ?", cutoff).Error
}
