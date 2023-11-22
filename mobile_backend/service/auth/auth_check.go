package auth

import (
	"context"
	"fmt"
	"mobile_backend/model"
	"mobile_backend/storage"
	"net/http"
	"time"

	"github.com/dgrijalva/jwt-go"
	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
)

func Authenticate(c *gin.Context){
	var user model.Account
	if err := c.BindJSON(&user); err !=nil{
		return
	}
	var checkingUser model.Account
	result := storage.DB.First(&checkingUser,"user_name = ?",user.UserName)
	if(result.Error !=nil){
		fmt.Println(result.Error)
	}
	checkResult := bcrypt.CompareHashAndPassword([]byte(checkingUser.Password),[]byte(user.Password))
	if checkResult == nil && result != nil{
		token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
			"username": user.UserName,
			"exp":      time.Now().Add(time.Hour * 1),
		})
		tokenString, err := token.SignedString([]byte("your-secret-key")) // Replace "your-secret-key" with your own secret key

		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		ctx := context.Background()
		errRedis := storage.RedisClient.Set(ctx, user.UserName, tokenString, 1*time.Hour).Err()
		if errRedis != nil {
			panic(errRedis)
		}

		val, err := storage.RedisClient.Get(ctx, user.UserName).Result()
		if err != nil {
			panic(err)
		}
		
		fmt.Println(user.UserName, val)
		c.JSON(http.StatusOK,gin.H{"user_name": "Bearer "+tokenString})
	}else{
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Wrong account infor"})
	}
}
