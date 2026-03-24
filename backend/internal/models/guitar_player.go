package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type GuitarPlayer struct {
	GuitarID  uuid.UUID `gorm:"type:uuid;primaryKey" json:"guitar_id"`
	PlayerID  uuid.UUID `gorm:"type:uuid;primaryKey" json:"player_id"`
	Note      *string   `gorm:"type:text" json:"note,omitempty"`
	Guitar    Guitar    `gorm:"foreignKey:GuitarID" json:"-"`
	Player    Player    `gorm:"foreignKey:PlayerID" json:"-"`
	CreatedAt time.Time `json:"created_at"`
}

func (GuitarPlayer) TableName() string {
	return "guitar_players"
}

func (gp *GuitarPlayer) BeforeCreate(tx *gorm.DB) error {
	if gp.CreatedAt.IsZero() {
		gp.CreatedAt = time.Now()
	}
	return nil
}
