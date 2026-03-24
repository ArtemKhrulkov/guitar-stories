package repository

import (
	"github.com/google/uuid"
	"gorm.io/gorm"

	"guitar-stock/internal/models"
)

type PlayerRepository struct {
	db *gorm.DB
}

func NewPlayerRepository(db *gorm.DB) *PlayerRepository {
	return &PlayerRepository{db: db}
}

func (r *PlayerRepository) FindAll() ([]models.Player, error) {
	var players []models.Player
	err := r.db.Order("name ASC").Find(&players).Error
	return players, err
}

func (r *PlayerRepository) FindByID(id uuid.UUID) (*models.Player, error) {
	var player models.Player
	err := r.db.First(&player, "id = ?", id).Error
	if err != nil {
		return nil, err
	}
	return &player, nil
}

func (r *PlayerRepository) FindByIDWithGuitars(id uuid.UUID) (*models.Player, []models.Guitar, error) {
	var player models.Player
	err := r.db.First(&player, "id = ?", id).Error
	if err != nil {
		return nil, nil, err
	}

	var guitars []models.Guitar
	err = r.db.Model(&player).Association("Guitars").Find(&guitars)
	if err != nil {
		return nil, nil, err
	}

	return &player, guitars, nil
}

func (r *PlayerRepository) Create(player *models.Player) error {
	return r.db.Create(player).Error
}

func (r *PlayerRepository) Update(player *models.Player) error {
	return r.db.Save(player).Error
}

func (r *PlayerRepository) Delete(id uuid.UUID) error {
	return r.db.Delete(&models.Player{}, "id = ?", id).Error
}
