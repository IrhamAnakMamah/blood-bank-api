package database

import (
	"fmt"


	"github.com/ReynardAdimas/blood-bank-api/config"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"


) 

func NewPostgresConnection(cfg *config.Config) (*gorm.DB, error) {
	dsn := fmt.Sprintf(
	"host=%s port=%s user=%s password=%s dbname=%s sslmode=%s TimeZone=Asia/Jakarta",
	cfg.DB.Host, cfg.DB.Port, cfg.DB.User,cfg.DB.Password, cfg.DB.Name, cfg.DB.SSLMode,
	) 
	logLevel := logger.Silent
	if cfg.AppEnv == "development" {
		logLevel = logger.Info
	} 

	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{
		Logger: logger.Default.LogMode(logLevel),
	}) 

	sqlDb, err := db.DB() 
	if err != nil {
		return nil, err
	} 

	sqlDb.SetMaxOpenConns(25)
	sqlDb.SetMaxIdleConns(10)
	return db, nil

}