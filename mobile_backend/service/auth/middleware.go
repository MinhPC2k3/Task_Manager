package auth

import (
	"fmt"
	"net/http"
	"strings"
	"time"
	"context"
	"mobile_backend/storage"
	"github.com/dgrijalva/jwt-go"
	"github.com/gin-gonic/gin"
)

func JWTMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		authorizationHeader := c.GetHeader("Authorization")
		fmt.Println(authorizationHeader)
		if authorizationHeader == "" {
			fmt.Println(0)
			c.AbortWithStatusJSON(http.StatusUnauthorized,gin.H{"Message":"Authorization header empty"})
			return
		}

		splitToken := strings.Split(authorizationHeader, "Bearer ")
		if len(splitToken) != 2 {
			fmt.Println(1)
			c.AbortWithStatusJSON(http.StatusUnauthorized,gin.H{"Message":"Wrong type of jwt"})
			return
		}
		tokenString := splitToken[1]

		token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
			// Verify the token signing method and return the secret key
			if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
				fmt.Println(2)
				return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
			}
			return []byte("your-secret-key"), nil
		})
		if err != nil {
			fmt.Println(3)
			fmt.Println("this is err :"+err.Error())
			// c.AbortWithStatusJSON(http.StatusUnauthorized,gin.H{"Message":"Can't parse jwt"})
			return
		}

		if !token.Valid {
			fmt.Println(4)
			c.AbortWithStatusJSON(http.StatusUnauthorized,gin.H{"Message":"token invalid"})
			return
		}

		claims, ok := token.Claims.(jwt.MapClaims)
		if !ok || !token.Valid {
			fmt.Println(5)
			c.AbortWithStatus(http.StatusUnauthorized)
			return
		}

		expirationString, ok := claims["exp"].(string)
		if !ok {
			fmt.Println(6)
			c.AbortWithStatus(http.StatusUnauthorized)
			return
		}

		expirationTime, err := time.Parse(time.RFC3339, expirationString)
		if err != nil {
			fmt.Println(7)
			c.AbortWithStatus(http.StatusUnauthorized)
			return
		}

		if time.Now().UTC().After(expirationTime) {
			fmt.Println(8)
			c.AbortWithStatusJSON(http.StatusForbidden,gin.H{"error": "Key expired"})			
			return
		}
		c.Set("user", claims["username"].(string))
		ctx := context.Background()
		val, _ := storage.RedisClient.Get(ctx, claims["username"].(string)).Result()
		if(val ==""){
			fmt.Println(9)
			c.AbortWithStatusJSON(http.StatusForbidden,gin.H{"error": "Key expired"})
		}
		fmt.Println(claims);
		c.Next()
	}
}

// if(claims["username"]!="admin"){
// 	c.JSON(http.StatusForbidden,gin.H{"error": "Permission deny"})
// 	c.AbortWithStatus(http.StatusForbidden)
// 	return
// }
