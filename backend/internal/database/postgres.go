package database

import (
	"fmt"
	"os"
	"path/filepath"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"

	"guitar-stock/internal/config"
	"guitar-stock/internal/models"
)

func Connect(cfg *config.Config) (*gorm.DB, error) {
	db, err := gorm.Open(postgres.Open(cfg.DatabaseURL), &gorm.Config{
		Logger: logger.Default.LogMode(logger.Info),
	})
	if err != nil {
		return nil, fmt.Errorf("failed to connect to database: %w", err)
	}

	sqlDB, err := db.DB()
	if err != nil {
		return nil, fmt.Errorf("failed to get underlying sql.DB: %w", err)
	}

	sqlDB.SetMaxIdleConns(10)
	sqlDB.SetMaxOpenConns(100)

	return db, nil
}

func Migrate(db *gorm.DB) error {
	return db.AutoMigrate(
		&models.Brand{},
		&models.Guitar{},
		&models.Player{},
		&models.GuitarPlayer{},
		&models.PurchaseLink{},
	)
}

func Seed(db *gorm.DB) error {
	var count int64
	db.Model(&models.Brand{}).Count(&count)
	if count > 0 {
		return nil
	}

	seedSQL, err := os.ReadFile(filepath.Join("migrations", "002_seed.sql"))
	if err != nil {
		return fmt.Errorf("failed to read seed file: %w", err)
	}

	if err := db.Exec(string(seedSQL)).Error; err != nil {
		return fmt.Errorf("failed to execute seed: %w", err)
	}

	return nil
}
