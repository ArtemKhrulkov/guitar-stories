package config

import (
	"github.com/spf13/viper"
)

type Config struct {
	Port           string
	DatabaseURL    string
	GinMode        string
	AllowedOrigins string
	AdminUser      string
	AdminPass      string
}

func Load() (*Config, error) {
	viper.SetConfigName(".env")
	viper.SetConfigType("env")
	viper.AddConfigPath(".")
	viper.AddConfigPath("..")

	viper.AutomaticEnv()

	if err := viper.ReadInConfig(); err != nil {
		if _, ok := err.(viper.ConfigFileNotFoundError); !ok {
			return nil, err
		}
	}

	cfg := &Config{
		Port:           viper.GetString("PORT"),
		DatabaseURL:    viper.GetString("DATABASE_URL"),
		GinMode:        viper.GetString("GIN_MODE"),
		AllowedOrigins: viper.GetString("ALLOWED_ORIGINS"),
		AdminUser:      viper.GetString("ADMIN_USER"),
		AdminPass:      viper.GetString("ADMIN_PASS"),
	}

	if cfg.Port == "" {
		cfg.Port = "8080"
	}
	if cfg.GinMode == "" {
		cfg.GinMode = "debug"
	}
	if cfg.AllowedOrigins == "" {
		cfg.AllowedOrigins = "http://localhost:3000"
	}
	if cfg.AdminUser == "" {
		cfg.AdminUser = "admin"
	}
	if cfg.AdminPass == "" {
		cfg.AdminPass = "changeme"
	}

	return cfg, nil
}
