package image

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"mobile_backend/storage"
	"mobile_backend/model"
	"github.com/gin-gonic/gin"
)

func PostImage (c *gin.Context) {

	productCode := c.Request.FormValue("text")
	file, _ := c.FormFile("file")
	log.Println(file.Filename)
	source,err := file.Open()
	if err!=nil {
		fmt.Println("fialed to open api file")
		return
	}

	saveFile,err1 := os.Create("./static/api_"+file.Filename)
	if err1!= nil{
		fmt.Println(" failed at create empty source file")
		c.String(http.StatusOK, fmt.Sprintf("'%s' failed at create empty source file", file.Filename))
		return
	}
	defer saveFile.Close()
	_,err3:= io.Copy(saveFile,source)
	if err3 != nil{
		fmt.Println("failed at copy file")
		fmt.Println(err3.Error())
		c.String(http.StatusOK, fmt.Sprintf("'%s' failed at copy file", file.Filename))
		return
	}

	storage.DB.Model(&model.Task{}).Where("code = ?", productCode).Update("product_image", "/static/api_"+file.Filename)

	c.String(http.StatusOK, fmt.Sprintf("'%s' uploaded!", file.Filename))
}
