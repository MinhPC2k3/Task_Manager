package storage

import (
	// "fmt"
	"mobile_backend/model"

	// "golang.org/x/crypto/bcrypt"
	// "golang.org/x/crypto/bcrypt"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var DB *gorm.DB

func Init() {
	dsn := "host=localhost user=postgres password= dbname=taskmanage port=5432 sslmode=disable TimeZone=Asia/Shanghai"
	db, _ := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	db.AutoMigrate(&model.Task{})
	db.AutoMigrate(&model.Account{})
	DB = db
	// hashedPass1,err := bcrypt.GenerateFromPassword([]byte("admin"),8)
	// hashedPass2,err := bcrypt.GenerateFromPassword([]byte("user"),8)
	// if err != nil{
	// 	fmt.Println(err)
	// }
	// myAccounts :=[] model.Account{
	// 	{UserName: "admin",Password: string(hashedPass1)},
	// 	{UserName: "user",Password: string(hashedPass2)},
	// }
	// db.Create(myAccounts)
}



// tasks := []*Task{
	// 	newTask(135794, "Giao hàng", "22 Kim Mã ,Đống Đa ,Hà Nội", 300000, 20000, time.Date(2023, time.October, 24, 9, 30, 0, 0, time.UTC), time.Now()),
	// }
	// tasks := Task{Target:  "Giao hàng",Destination:  "22 Kim Mã ,Đống Đa ,Hà Nội", ProductValue:  300000,ShipCost:  20000,Deathline:  time.Date(2023, time.October, 24, 9, 30, 0, 0, time.UTC),CreateAt:  time.Now()}
	// result := db.Create(&tasks)
	// if result.Error !=nil {
	// 	fmt.Println("Error:", result.Error)
	// }else {
	// 	var records []Task
	// 	db.Find(&records)
	// 	for _,v := range records{
	// 		fmt.Printf("My record %s\n",v.Destination)
	// 	}
	//     fmt.Println("New record ID:", result.RowsAffected)
	// }
//	func newTask(id int, target, destination, code, status string, productValue, shipCost int, deathline, createAt string) *Task {
//		return &Task{id, code, status, target, destination, productValue, shipCost, deathline}
//	}
