package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type PriceHistory struct {
	ID             uuid.UUID `gorm:"type:uuid;primary_key;column:id" json:"id"`
	PurchaseLinkID uuid.UUID `gorm:"type:uuid;not null;column:purchase_link_id" json:"purchase_link_id"`
	PriceRUB       *float64  `gorm:"type:decimal(10,2);column:price_rub" json:"price_rub,omitempty"`
	PriceUSD       *float64  `gorm:"type:decimal(10,2);column:price_usd" json:"price_usd,omitempty"`
	RecordedAt     time.Time `gorm:"default:NOW();column:recorded_at" json:"recorded_at"`
}

func (PriceHistory) TableName() string {
	return "price_history"
}

func (ph *PriceHistory) BeforeCreate(tx *gorm.DB) error {
	if ph.ID == uuid.Nil {
		ph.ID = uuid.New()
	}
	return nil
}
