package repository

import (
	"github.com/google/uuid"
	"gorm.io/gorm"

	"guitar-stock/internal/models"
)

type BrandRepository struct {
	db *gorm.DB
}

func NewBrandRepository(db *gorm.DB) *BrandRepository {
	return &BrandRepository{db: db}
}

func (r *BrandRepository) FindAll() ([]models.Brand, error) {
	var brands []models.Brand
	err := r.db.Order("name ASC").Find(&brands).Error
	return brands, err
}

func (r *BrandRepository) FindByID(id uuid.UUID) (*models.Brand, error) {
	var brand models.Brand
	err := r.db.First(&brand, "id = ?", id).Error
	if err != nil {
		return nil, err
	}
	return &brand, nil
}

func (r *BrandRepository) FindByIDWithGuitars(id uuid.UUID) (*models.Brand, []models.Guitar, error) {
	var brand models.Brand
	err := r.db.First(&brand, "id = ?", id).Error
	if err != nil {
		return nil, nil, err
	}

	var guitars []models.Guitar
	err = r.db.Where("brand_id = ?", id).Find(&guitars).Error
	if err != nil {
		return nil, nil, err
	}

	return &brand, guitars, nil
}

func (r *BrandRepository) Create(brand *models.Brand) error {
	return r.db.Create(brand).Error
}

func (r *BrandRepository) Update(brand *models.Brand) error {
	return r.db.Save(brand).Error
}

func (r *BrandRepository) Delete(id uuid.UUID) error {
	return r.db.Delete(&models.Brand{}, "id = ?", id).Error
}
