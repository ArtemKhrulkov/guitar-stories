package scraper

import (
	"context"
	"fmt"
	"log"
	"regexp"
	"strconv"
	"strings"
	"time"

	"github.com/chromedp/chromedp"
)

type WildberriesScraper struct{}

func NewWildberriesScraper() *WildberriesScraper {
	return &WildberriesScraper{}
}

func (s *WildberriesScraper) Search(brand, model string) ([]SearchResult, error) {
	var results []SearchResult
	query := fmt.Sprintf("%s %s гитара", brand, model)
	searchURL := fmt.Sprintf("https://www.wildberries.ru/catalog/0/search.aspx?search=%s", strings.ReplaceAll(query, " ", "%20"))

	log.Printf("[WB] Searching: %s", searchURL)

	ctx, cancel := context.WithTimeout(context.Background(), 60*time.Second)
	defer cancel()

	allocCtx, allocCancel := chromedp.NewExecAllocator(ctx,
		chromedp.NoSandbox,
		chromedp.Headless,
		chromedp.DisableGPU,
	)
	defer allocCancel()

	ctx, cancel = chromedp.NewContext(allocCtx)
	defer cancel()

	var productLinks []string
	var productTitles []string

	err := chromedp.Run(ctx,
		chromedp.Navigate(searchURL),
		chromedp.Sleep(5*time.Second),
		chromedp.WaitVisible(`article.product-card`, chromedp.ByQuery),
		chromedp.ActionFunc(func(ctx context.Context) error {
			var jsResults []map[string]string
			err := chromedp.Evaluate(`
				(function() { 
					const items = document.querySelectorAll('article.product-card a[data-link]'); 
					return Array.from(items).map(a => ({ 
						href: a.href || a.getAttribute('data-link') || '', 
						title: a.querySelector('.product-card__name')?.textContent?.trim() || 
							   a.querySelector('.goods-name')?.textContent?.trim() || '' 
					})); 
				})()
			`, &jsResults).Do(ctx)

			if err != nil {
				log.Printf("[WB] Error evaluating: %v", err)
				return err
			}

			for _, item := range jsResults {
				if item["href"] != "" {
					link := item["href"]
					if !strings.HasPrefix(link, "http") {
						link = "https://www.wildberries.ru" + link
					}
					productLinks = append(productLinks, link)
					productTitles = append(productTitles, item["title"])
				}
			}
			return nil
		}),
	)

	if err != nil {
		log.Printf("[WB] Chromedp error: %v", err)
		return results, nil
	}

	for i, link := range productLinks {
		title := ""
		if i < len(productTitles) {
			title = strings.TrimSpace(productTitles[i])
		}

		result := SearchResult{
			URL:     link,
			Title:   title,
			InStock: true,
		}

		if link != "" {
			log.Printf("[WB] Found: %s - %s", title, link)
			results = append(results, result)
		}
	}

	if len(results) > 10 {
		results = results[:10]
	}

	log.Printf("[WB] Found %d results", len(results))
	return results, nil
}

func parseWBPrice(text string) *float64 {
	re := regexp.MustCompile(`[\d\s]+`)
	matches := re.FindAllString(text, -1)
	if len(matches) == 0 {
		return nil
	}

	cleaned := strings.ReplaceAll(matches[0], " ", "")
	price, err := strconv.ParseFloat(cleaned, 64)
	if err != nil {
		return nil
	}

	return &price
}
