package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Brand struct {
	ID          uuid.UUID `gorm:"type:uuid;primary_key" json:"id"`
	Name        string    `gorm:"size:255;not null;unique" json:"name"`
	Country     string    `gorm:"size:100;not null" json:"country"`
	FoundedYear *int      `json:"founded_year,omitempty"`
	Description *string   `gorm:"type:text" json:"description,omitempty"`
	LogoURL     *string   `gorm:"size:500" json:"logo_url,omitempty"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
	Guitars     []Guitar  `gorm:"foreignKey:BrandID" json:"guitars,omitempty"`
}

func (b *Brand) BeforeCreate(tx *gorm.DB) error {
	if b.ID == uuid.Nil {
		b.ID = uuid.New()
	}
	return nil
}
