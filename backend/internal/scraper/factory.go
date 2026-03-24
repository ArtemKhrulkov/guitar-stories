package scraper

type Platform string

const (
	Ozon        Platform = "ozon"
	Wildberries Platform = "wildberries"
)

type SearchResult struct {
	URL      string
	Title    string
	PriceRUB *float64
	PriceUSD *float64
	InStock  bool
}

type Scraper interface {
	Search(brand, model string) ([]SearchResult, error)
}

func NewScraper(platform Platform) Scraper {
	switch platform {
	case Ozon:
		return &OzonScraper{}
	case Wildberries:
		return &WildberriesScraper{}
	default:
		return &OzonScraper{}
	}
}
