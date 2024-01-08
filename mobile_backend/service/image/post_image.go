package image

import (
	"fmt"
	"io"
	"log"
	"mobile_backend/model"
	"mobile_backend/storage"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
)

func PostImage(c *gin.Context) {

	productCode := c.Request.FormValue("text")
	file, _ := c.FormFile("file")
	log.Println(file.Filename)
	source, err := file.Open()
	if err != nil {
		fmt.Println("fialed to open api file")
		return
	}

	saveFile, err1 := os.Create("./static/api_" + file.Filename)
	if err1 != nil {
		fmt.Println(" failed at create empty source file")
		c.String(http.StatusOK, fmt.Sprintf("'%s' failed at create empty source file", file.Filename))
		return
	}
	defer saveFile.Close()
	_, err3 := io.Copy(saveFile, source)
	if err3 != nil {
		fmt.Println("failed at copy file")
		fmt.Println(err3.Error())
		c.String(http.StatusOK, fmt.Sprintf("'%s' failed at copy file", file.Filename))
		return
	}

	storage.DB.Model(&model.Task{}).Where("code = ?", productCode).Update("product_image", "/static/api_"+file.Filename)

	c.String(http.StatusOK, fmt.Sprintf("'%s' uploaded!", file.Filename))
}

func PostDeleteImage(c *gin.Context) {
	type Body struct {
		TaskCode string `json:"Code"`
	}
	var taskCode Body
	if err := c.BindJSON(&taskCode); err != nil {
		return
	}
	fmt.Println(taskCode)
	var tempTask model.Task
	err2 := storage.DB.Where("code = ?", taskCode.TaskCode).Find(&tempTask).Error
	if err2 != nil {
		panic("Failed to update the record")
	}
	errDeleteFile := os.Remove("./" + tempTask.ProductImage)
	if errDeleteFile != nil {
		fmt.Println(errDeleteFile.Error())
	}
	err1 := storage.DB.Model(&model.Task{}).Where("code = ?", taskCode.TaskCode).Update("product_image", nil).Error
	if err1 != nil {
		panic("Failed to update the record")
	}
	fmt.Println(tempTask.ProductImage)
	c.JSON(http.StatusOK, gin.H{"task_code": taskCode})

}
