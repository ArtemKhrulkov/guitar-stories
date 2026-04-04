package repository

import (
	"github.com/google/uuid"
	"gorm.io/gorm"

	"guitar-stock/internal/models"
)

type WishlistRepository struct {
	db *gorm.DB
}

func NewWishlistRepository(db *gorm.DB) *WishlistRepository {
	return &WishlistRepository{db: db}
}

func (r *WishlistRepository) FindByUserID(userID uuid.UUID) ([]models.Wishlist, error) {
	var wishlists []models.Wishlist
	err := r.db.Preload("Guitar").Where("user_id = ?", userID).Order("created_at DESC").Find(&wishlists).Error
	return wishlists, err
}

func (r *WishlistRepository) FindByUserAndGuitar(userID, guitarID uuid.UUID) (*models.Wishlist, error) {
	var wishlist models.Wishlist
	err := r.db.Where("user_id = ? AND guitar_id = ?", userID, guitarID).First(&wishlist).Error
	if err != nil {
		return nil, err
	}
	return &wishlist, nil
}

func (r *WishlistRepository) Create(wishlist *models.Wishlist) error {
	return r.db.Create(wishlist).Error
}

func (r *WishlistRepository) Delete(id uuid.UUID) error {
	return r.db.Delete(&models.Wishlist{}, "id = ?", id).Error
}

func (r *WishlistRepository) DeleteByUserAndGuitar(userID, guitarID uuid.UUID) error {
	return r.db.Where("user_id = ? AND guitar_id = ?", userID, guitarID).Delete(&models.Wishlist{}).Error
}

func (r *WishlistRepository) DeleteAllByUserID(userID uuid.UUID) error {
	return r.db.Where("user_id = ?", userID).Delete(&models.Wishlist{}).Error
}

func (r *WishlistRepository) CountByUserID(userID uuid.UUID) (int64, error) {
	var count int64
	err := r.db.Model(&models.Wishlist{}).Where("user_id = ?", userID).Count(&count).Error
	return count, err
}

func (r *WishlistRepository) AddMultiple(userID uuid.UUID, guitarIDs []uuid.UUID) error {
	if len(guitarIDs) == 0 {
		return nil
	}

	var wishlists []models.Wishlist
	for _, guitarID := range guitarIDs {
		wishlists = append(wishlists, models.Wishlist{
			UserID:   userID,
			GuitarID: guitarID,
		})
	}

	// Use upsert to skip duplicates
	for i := range wishlists {
		err := r.db.Where("user_id = ? AND guitar_id = ?", wishlists[i].UserID, wishlists[i].GuitarID).
			Assign(models.Wishlist{CreatedAt: wishlists[i].CreatedAt}).
			FirstOrCreate(&wishlists[i]).Error
		if err != nil {
			return err
		}
	}
	return nil
}
