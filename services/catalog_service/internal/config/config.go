package config

import (
	"github.com/spf13/viper"
	"log"
)

type Config struct {
	Server struct {
		Port     string
		GrpcPort string
	}
	Mongo struct {
		Uri string
		Db  string
	}
	Elasticsearch struct {
		Url string
	}
	ExternalApis struct {
		OneSixEightEightKey    string
		OneSixEightEightSecret string
	}
}

func LoadConfig() *Config {
	viper.SetConfigName("config")
	viper.SetConfigType("yaml")
	viper.AddConfigPath("./internal/config")
	viper.AutomaticEnv()

	if err := viper.ReadInConfig(); err != nil {
		log.Printf("Error reading config file, %s", err)
	}

	var cfg Config
	if err := viper.Unmarshal(&cfg); err != nil {
		log.Fatalf("Unable to decode into struct, %v", err)
	}

	return &cfg
}
