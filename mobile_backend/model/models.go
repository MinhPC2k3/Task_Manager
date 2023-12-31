package model

import "gorm.io/gorm"

type Account struct {
	UserName string `json:"UserName" gorm:"primaryKey"`
	Password string `json:"Password"`
	gorm.Model
}

type Task struct {
	// ID           int    `gorm:"primaryKey;autoIncrement:true"  json:"ID"`
	Status       string  `json:"Status"`
	Code         string  `json:"Code" gorm:"primaryKey"`
	Target       string  `json:"Target"`
	Destination  string  `json:"Destination"`
	ProductValue int     `json:"ProductValue"`
	ShipCost     int     `json:"ShipCost"`
	Deathline    string  `json:"DeathLine"`
	ProductImage string  `json:"ImagePath"`
	LatValue     float64 `json:"LatValue"`
	LngValue     float64 `json:"LngValue"`
	gorm.Model
}
