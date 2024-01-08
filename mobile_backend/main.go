package main

import (
	// "fmt"
	// "io"
	// "log"
	// "net/http"
	// "os"
	// "mobile_backend/model"
	"mobile_backend/service/auth"
	"mobile_backend/service/image"
	"mobile_backend/service/mail"
	"mobile_backend/service/mobile"
	"mobile_backend/storage"

	"github.com/gin-gonic/gin"
)



func main() {
	// mail.SendEmail()
	storage.RedisInit()
	storage.Init()
	// var myTasks = []model.Task{
	// 	{ Status: "Đơn mới", Code: "#135794", Target: "Giao hàng", Destination: "22 Kim Mã ,Đống Đa ,Hà Nội", ProductValue: 300000, ShipCost: 20000, Deathline: "2023-10-24 09:30:00",LatValue:21.031247564706984,LngValue:105.821689479053},
	// 	{Status: "Chờ lấy hàng", Code: "#246801", Target: "Lấy hàng", Destination: "Nhà thờ lớn", ProductValue: 0, ShipCost: 15000,  Deathline: "2023-10-24 08:30:00",LatValue:  21.028921764176328,LngValue: 105.84965184330942},
	// 	{Status: "Chờ lấy hàng", Code: "#123456", Target: "Lấy hàng", Destination: "369 Trần Phú, Hà Đông", ProductValue: 0, ShipCost: 30000,  Deathline: "2023-10-24 15:30:00",LatValue: 20.983415525650805,LngValue: 105.78928872942923},
	// 	{Status: "Đơn mới", Code: "#798668", Target: "Giao hàng", Destination: "Kaengnam 72", ProductValue: 500000, ShipCost: 25000,  Deathline: "2023-10-24 11:00:00",LatValue:  21.017020871082327,LngValue:  105.78413721174},
	// }
	
	// storage.DB.Create(&myTasks)
	r := gin.Default()
	// r.LoadHTMLGlob("template/*")
	r.LoadHTMLGlob("template/*")
	//router.LoadHTMLFiles("templates/template1.html", "templates/template2.html")
	r.GET("/get/mail/index.html", mail.SendEmail)
	r.GET("/get",auth.JWTMiddleware(), mobile.GetTask)
	r.POST("/post/ChangePassword",auth.JWTMiddleware(),auth.ChangePassword(),mobile.LogoutUser)
	// r.GET("/get/index.html",mail.HtmlDisplay)
	r.POST("/post", auth.JWTMiddleware(),mobile.PostTask)
	r.POST("/post/authenticate",auth.Authenticate)
	r.GET("/get/logout",mobile.LogoutUser)
	r.Static("/static","./static")
	r.POST("/post/upload", image.PostImage)
	r.POST("/post/delete_image",image.PostDeleteImage)
	r.Run() 

}


// var myTasks = []storage.Task{
	// 	{ Status: "Đơn mới", Code: "#135794", Target: "Giao hàng", Destination: "22 Kim Mã ,Đống Đa ,Hà Nội", ProductValue: 300000, ShipCost: 20000, Deathline: "2023-10-24 09:30:00",LatValue:21.031247564706984,LngValue:105.821689479053},
	// 	{Status: "Chờ lấy hàng", Code: "#246801", Target: "Lấy hàng", Destination: "Nhà thờ lớn", ProductValue: 0, ShipCost: 15000,  Deathline: "2023-10-24 08:30:00",LatValue:  21.028921764176328,LngValue: 105.84965184330942},
	// 	{Status: "Chờ lấy hàng", Code: "#123456", Target: "Lấy hàng", Destination: "369 Trần Phú, Hà Đông", ProductValue: 0, ShipCost: 30000,  Deathline: "2023-10-24 15:30:00",LatValue: 20.983415525650805,LngValue: 105.78928872942923},
	// 	{Status: "Đơn mới", Code: "#798668", Target: "Giao hàng", Destination: "Kaengnam 72", ProductValue: 500000, ShipCost: 25000,  Deathline: "2023-10-24 11:00:00",LatValue:  21.017020871082327,LngValue:  105.78413721174},
	// }
	
	// storage.DB.Create(&myTasks)
	// var albums = []album{
	// 	{ID: "1", Title: "Blue Train", Artist: "John Coltrane", Price: 56.99},
	// 	{ID: "2", Title: "Jeru", Artist: "Gerry Mulligan", Price: 17.99},
	// 	{ID: "3", Title: "Sarah Vaughan and Clifford Brown", Artist: "Sarah Vaughan", Price: 39.99},
	// }