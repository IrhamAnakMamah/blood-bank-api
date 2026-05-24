package redisinfra 

import (
	"context"
	"fmt"
	"log"
	"time" 

	"github.com/redis/go-redis/v9"
	"github.com/ReynardAdimas/blood-bank-api/config"

) 

func NewRedisClient(cfg *config.Config) (*redis.Client, error) {
	rdb := redis.NewClient(&redis.Options{
		Addr: cfg.Redis.Addr,
		Password: cfg.Redis.Password,
		DB: cfg.Redis.DB,
	}) 

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel() 

	if err := rdb.Ping(ctx).Err(); err != nil {
		return nil, fmt.Errorf("failed to connect to redis: %w", err)
	}

	log.Printf("Redis connected")
	return rdb, nil
}