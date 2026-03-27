package scraper

import (
	"context"

	"github.com/sirupsen/logrus"
)

type OzonScraper struct {
	logger *logrus.Logger
}

func NewOzonScraper() *OzonScraper {
	logger := logrus.New()
	logger.SetFormatter(&logrus.TextFormatter{FullTimestamp: true})
	return &OzonScraper{logger: logger}
}

func NewOzonScraperWithProxies(_ []string) *OzonScraper {
	return NewOzonScraper()
}

func NewOzonScraperWithDebug() *OzonScraper {
	return NewOzonScraper()
}

func NewOzonScraperManual() *OzonScraper {
	return NewOzonScraper()
}

func (s *OzonScraper) Search(_ context.Context, _, _ string) ([]SearchResult, error) {
	s.logger.Infof("[OZON] Manual mode - Ozon scraping blocked by anti-bot. Use manual links instead.")
	return []SearchResult{}, nil
}
