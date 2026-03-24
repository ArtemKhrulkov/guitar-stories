package main

import (
	"log"
	"os"

	"guitar-stock/internal/config"
	"guitar-stock/internal/database"
	"guitar-stock/internal/router"
	"guitar-stock/internal/scraper"

	"github.com/sirupsen/logrus"
)

func main() {
	logrus.SetFormatter(&logrus.JSONFormatter{})
	logrus.SetOutput(os.Stdout)
	logrus.SetLevel(logrus.InfoLevel)

	cfg, err := config.Load()
	if err != nil {
		logrus.Fatalf("Failed to load config: %v", err)
	}

	db, err := database.Connect(cfg)
	if err != nil {
		logrus.Fatalf("Failed to connect to database: %v", err)
	}

	if err := database.Migrate(db); err != nil {
		logrus.Fatalf("Failed to run migrations: %v", err)
	}

	if err := database.Seed(db); err != nil {
		logrus.Warnf("Warning: Failed to seed database: %v", err)
	}

	scraperService := scraper.NewService(db)
	scraperService.StartScheduler()

	r := router.Setup(db, cfg)

	port := cfg.Port
	if port == "" {
		port = "8080"
	}

	logrus.Infof("Starting server on port %s", port)
	if err := r.Run(":" + port); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}
