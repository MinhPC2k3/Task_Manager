package auth

import (
	"fmt"
	"net/http"
	// "mobile_backend/model"
	// "mobile_backend/storage"
	// "net/http"
	"mobile_backend/model"
	"mobile_backend/storage"
	"reflect"

	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
)
func ChangePassword() gin.HandlerFunc{
	return func(ctx *gin.Context){
		data,_ := ctx.Get("user")
		var newUserInfor map[string]string
		err1 := ctx.BindJSON(&newUserInfor)
		if err1!=nil{
			ctx.AbortWithStatusJSON(http.StatusBadRequest,gin.H{"Message":"wrong JSON information"})
			return
		}
		fmt.Println(newUserInfor)
		fmt.Println("this is roll",data)
		fmt.Println(reflect.ValueOf(data).Kind())
		if data == "admin"{
			fmt.Println("this is admin")
		}
		var checkingUser model.Account
		result := storage.DB.First(&checkingUser,"user_name = ?",data)
		if(result.Error !=nil){
			fmt.Println(result.Error)
		}
		checkResult := bcrypt.CompareHashAndPassword([]byte(checkingUser.Password),[]byte(newUserInfor["Password"]))
		pwdStorage ,_:= bcrypt.GenerateFromPassword([]byte(newUserInfor["NewPassword"]),8)
		fmt.Println("this pwd " + string(pwdStorage))
		if checkResult == nil{
			storage.DB.Model(&model.Account{}).Where("user_name = ?",data).Update("password",string(pwdStorage))
			// ctx.JSON(http.StatusOK,gin.H{"Message":"Change password complete"})
			ctx.Status(http.StatusOK);
		}else {
			fmt.Println("this err :" +checkResult.Error())
			ctx.AbortWithStatusJSON(http.StatusUnauthorized,gin.H{"Message":"Wrong old password"})
			
		}
		ctx.Next()
	}

}
