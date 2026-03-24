package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Player struct {
	ID        uuid.UUID `gorm:"type:uuid;primary_key" json:"id"`
	Name      string    `gorm:"size:255;not null" json:"name"`
	Genre     string    `gorm:"size:100" json:"genre"`
	Bio       *string   `gorm:"type:text" json:"bio,omitempty"`
	ImageURL  *string   `gorm:"size:500" json:"image_url,omitempty"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
	Guitars   []Guitar  `gorm:"many2many:guitar_players;" json:"guitars,omitempty"`
}

func (p *Player) BeforeCreate(tx *gorm.DB) error {
	if p.ID == uuid.Nil {
		p.ID = uuid.New()
	}
	return nil
}
