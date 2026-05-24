package config 
import (
	"os"
	"strconv"
	"time" 
) 

type Config struct {
	AppPort string 
	AppEnv string 
	DB DBConfig 
	Redis RedisConfig 
	JWT JWTConfig 
	QRKey string
} 

type DBConfig struct {
	Host string 
	Port string 
	User string 
	Password string 
	Name string 
	SSLMode string
} 

type RedisConfig struct {
	Addr string 
	Password string 
	DB int
} 

type JWTConfig struct {
	Secret string 
	DonorExpiry time.Duration 
	AdminExpiry time.Duration 
	RefreshExpiry time.Duration
}

func getEnv(key, fallback string) string {
	if v:= os.Getenv(key); v != "" {
		return v
	}
	return fallback
}

func Load() *Config {
	redisDB, _ := strconv.Atoi(getEnv("Redis_DB", "0"))
	donorExpiry, _ := time.ParseDuration(getEnv("JWT_DONOR_EXPIRY","24h"))
	adminExpiry, _ := time.ParseDuration(getEnv("JWT_ADMIN_EXPIRY", "8h"))
	refreshExpiry, _ := time.ParseDuration(getEnv("JWT_REFRESH_EXPIRY", "168h")) 

	return &Config{
		AppPort: getEnv("APP_PORT", "8080"),
		AppEnv: getEnv("APP_ENV", "development"),
		DB: DBConfig{
			Host: getEnv("DB_HOST", "localhost"),
			Port: getEnv("DB_PORT", "5432"),
			User: getEnv("DB_USER", "postgres"),
			Password: getEnv("DB_PASSWORD", ""),
			Name: getEnv("DB_NAME", "blood_bank"),
			SSLMode: getEnv("DB_SSLMODE", "disable"),
		},
		Redis: RedisConfig{
			Addr: getEnv("REDIS_ADDR", "localhost:6379"),
			Password: getEnv("REDIS_PASSWORD", ""),
			DB: redisDB,
		},
		JWT: JWTConfig{
			Secret: getEnv("JWT_SECRET", ""),
			DonorExpiry: donorExpiry,
			AdminExpiry: adminExpiry,
			RefreshExpiry: refreshExpiry,
		},
		QRKey: getEnv("QR_ENCRYPTION_KEY", ""),
	}
} 

