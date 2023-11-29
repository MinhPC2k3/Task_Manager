package mobile

import (
	"context"
	"fmt"
	"math/rand"
	"mobile_backend/model"
	"mobile_backend/storage"
	"net/http"
	"strconv"
	"strings"
	"time"
	"github.com/dgrijalva/jwt-go"
	"github.com/gin-gonic/gin"
)

func SortTask(myListTask []model.Task) {
	fmt.Println("doing func")
	for index := range myListTask {
		var tempIndex = index
		for tempIndex > 0 {
			tempDateI, _ := time.Parse("2006-01-02 15:04:05", myListTask[tempIndex].Deathline)
			tempDateJ, _ := time.Parse("2006-01-02 15:04:05", myListTask[tempIndex-1].Deathline)
			if tempDateI.Before(tempDateJ) {
				setVar := myListTask[tempIndex]
				myListTask[tempIndex] = myListTask[tempIndex-1]
				myListTask[tempIndex-1] = setVar
			}
			tempIndex--
		}
	}
}

func GetTask (c *gin.Context) {
	var listTask []model.Task
	storage.DB.Find(&listTask)
	SortTask(listTask)
	c.JSON(http.StatusOK, listTask)
}

func PostTask (ctx *gin.Context) {
	min := 10000 // Minimum 5-digit number
	max := 99999 // Maximum 5-digit number
	// data,err := ctx.Get("user")
	// if err {
	// 	fmt.Println(err)
	// }
	// fmt.Println(data)
	// if(data)
	randomNumber := min + rand.Intn(max-min+1)
	var newTask model.Task
	newTask.LatValue = 21.028921764176328
	newTask.LngValue = 105.84965184330942
	if err := ctx.BindJSON(&newTask); err != nil {
		return
	}
	newTask.Code = "#"+strconv.Itoa(randomNumber)
	storage.DB.Create(&newTask)
	ctx.JSON(http.StatusOK, "post done")
}
func LogoutUser(ctx *gin.Context) {
	userJwtToken := ctx.GetHeader("Authorization")
	if userJwtToken == "" {
		ctx.JSON(http.StatusBadRequest, "Cannot parse jwt")
		return
	}
	splitToken := strings.Split(userJwtToken, "Bearer ")
	tokenString := splitToken[1]
	token, _ := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		// Verify the token signing method and return the secret key
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		return []byte("your-secret-key"), nil
	})
	claims, _ := token.Claims.(jwt.MapClaims)
	c:= context.Background()
	storage.RedisClient.Del(c,claims["username"].(string)).Result()

	ctx.SetCookie("token", "", -1, "/", "localhost", false, true)
	ctx.JSON(http.StatusOK, gin.H{"Message": "success"})
}