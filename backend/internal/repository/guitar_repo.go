package repository

import (
	"strings"

	"github.com/google/uuid"
	"gorm.io/gorm"

	"guitar-stock/internal/models"
)

type GuitarRepository struct {
	db *gorm.DB
}

func NewGuitarRepository(db *gorm.DB) *GuitarRepository {
	return &GuitarRepository{db: db}
}

type GuitarFilter struct {
	BrandID *uuid.UUID
	Type    *models.GuitarType
	Search  *string
	Page    int
	Limit   int
}

func (r *GuitarRepository) FindAll(filter GuitarFilter) ([]models.Guitar, int64, error) {
	var guitars []models.Guitar
	var total int64

	query := r.db.Model(&models.Guitar{})

	if filter.BrandID != nil {
		query = query.Where("brand_id = ?", *filter.BrandID)
	}

	if filter.Type != nil {
		query = query.Where("guitar_type = ?", *filter.Type)
	}

	if filter.Search != nil && *filter.Search != "" {
		searchTerm := "%" + strings.ToLower(*filter.Search) + "%"
		query = query.Where("LOWER(model) LIKE ? OR LOWER(history) LIKE ?", searchTerm, searchTerm)
	}

	query.Count(&total)

	if filter.Page < 1 {
		filter.Page = 1
	}
	if filter.Limit < 1 {
		filter.Limit = 12
	}

	offset := (filter.Page - 1) * filter.Limit
	err := query.Preload("Brand").
		Order("created_at DESC").
		Offset(offset).
		Limit(filter.Limit).
		Find(&guitars).Error

	return guitars, total, err
}

func (r *GuitarRepository) FindByID(id uuid.UUID) (*models.Guitar, error) {
	var guitar models.Guitar
	err := r.db.Preload("Brand").
		Preload("Players").
		Preload("PurchaseLinks").
		Preload("PurchaseLinks.PriceHistory", func(db *gorm.DB) *gorm.DB {
			return db.Order("price_history.recorded_at DESC").Limit(10)
		}).
		First(&guitar, "id = ?", id).Error
	if err != nil {
		return nil, err
	}
	return &guitar, nil
}

func (r *GuitarRepository) FindByBrandID(brandID uuid.UUID) ([]models.Guitar, error) {
	var guitars []models.Guitar
	err := r.db.Where("brand_id = ?", brandID).Find(&guitars).Error
	return guitars, err
}

func (r *GuitarRepository) Create(guitar *models.Guitar) error {
	return r.db.Create(guitar).Error
}

func (r *GuitarRepository) Update(guitar *models.Guitar) error {
	return r.db.Save(guitar).Error
}

func (r *GuitarRepository) Delete(id uuid.UUID) error {
	return r.db.Delete(&models.Guitar{}, "id = ?", id).Error
}

func (r *GuitarRepository) FindAllIDs() ([]uuid.UUID, error) {
	var ids []uuid.UUID
	err := r.db.Model(&models.Guitar{}).Pluck("id", &ids).Error
	return ids, err
}

func (r *GuitarRepository) GetBrand(guitarID uuid.UUID) (*models.Brand, error) {
	var guitar models.Guitar
	err := r.db.Preload("Brand").First(&guitar, "id = ?", guitarID).Error
	if err != nil {
		return nil, err
	}
	return guitar.Brand, nil
}
