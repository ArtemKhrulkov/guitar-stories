package repository

import (
	"errors"
	"time"

	"github.com/google/uuid"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"

	"guitar-stock/internal/models"
)

type UserRepository struct {
	db *gorm.DB
}

func NewUserRepository(db *gorm.DB) *UserRepository {
	return &UserRepository{db: db}
}

func (r *UserRepository) FindAll() ([]models.User, error) {
	var users []models.User
	err := r.db.Order("created_at DESC").Find(&users).Error
	return users, err
}

func (r *UserRepository) FindByID(id uuid.UUID) (*models.User, error) {
	var user models.User
	err := r.db.First(&user, "id = ?", id).Error
	if err != nil {
		return nil, err
	}
	return &user, nil
}

func (r *UserRepository) FindByEmail(email string) (*models.User, error) {
	var user models.User
	err := r.db.First(&user, "email = ?", email).Error
	if err != nil {
		return nil, err
	}
	return &user, nil
}

func (r *UserRepository) FindByEmailIncludeUnverified(email string) (*models.User, error) {
	var user models.User
	err := r.db.Unscoped().First(&user, "email = ?", email).Error
	if err != nil {
		return nil, err
	}
	return &user, nil
}

func (r *UserRepository) Create(user *models.User) error {
	return r.db.Create(user).Error
}

func (r *UserRepository) Update(user *models.User) error {
	return r.db.Save(user).Error
}

func (r *UserRepository) Delete(id uuid.UUID) error {
	return r.db.Delete(&models.User{}, "id = ?", id).Error
}

func (r *UserRepository) HashPassword(password string) (string, error) {
	bytes, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	return string(bytes), err
}

func (r *UserRepository) CheckPassword(password, hash string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
	return err == nil
}

func (r *UserRepository) CreateVerification(verification *models.UserVerification) error {
	return r.db.Create(verification).Error
}

func (r *UserRepository) FindVerification(userID uuid.UUID, code string, verificationType string) (*models.UserVerification, error) {
	var v models.UserVerification
	err := r.db.Where("user_id = ? AND code = ? AND type = ? AND used = false", userID, code, verificationType).First(&v).Error
	if err != nil {
		return nil, err
	}
	return &v, nil
}

func (r *UserRepository) MarkVerificationUsed(id uuid.UUID) error {
	return r.db.Model(&models.UserVerification{}).Where("id = ?", id).Update("used", true).Error
}

func (r *UserRepository) DeleteExpiredVerifications(userID uuid.UUID) error {
	return r.db.Where("user_id = ? AND expires_at < ?", userID, time.Now()).Delete(&models.UserVerification{}).Error
}

func (r *UserRepository) FindValidVerification(userID uuid.UUID, code string, verificationType string) (*models.UserVerification, error) {
	var v models.UserVerification
	err := r.db.Where("user_id = ? AND code = ? AND type = ? AND used = false AND expires_at > ?", userID, code, verificationType, time.Now()).First(&v).Error
	if err != nil {
		return nil, err
	}
	return &v, nil
}

func (r *UserRepository) FindUserByEmailForReset(email string) (*models.User, error) {
	var user models.User
	err := r.db.Unscoped().Where("email = ? AND email_verified = true", email).First(&user).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, errors.New("user not found or email not verified")
		}
		return nil, err
	}
	return &user, nil
}

func (r *UserRepository) HardDelete(id uuid.UUID) error {
	return r.db.Unscoped().Delete(&models.User{}, "id = ?", id).Error
}
