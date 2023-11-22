package mail

import (
	"fmt"
	"html/template"
	"net/http"

	"github.com/gin-gonic/gin"
)

type Page struct {
    Title   string
    Heading string
    Message string
}

func HtmlDisplay (ctx *gin.Context){
	tmpl, err := template.ParseFiles("template/index.tmpl")
    if err != nil {
		fmt.Println("this is error"+err.Error());
        ctx.JSON(http.StatusNotFound,gin.H{"status":"html file not found"})
        return
    }

    // Dữ liệu cho template
    data := Page{
        Title:   "Xác nhận đổi mật khẩu",
        Heading: "Xin chào",
        Message: "Nhấn vào nút bên dưới để cài lại mật khẩu",
    }

    // Hiển thị template với dữ liệu đã cung cấp
    err = tmpl.Execute(ctx.Writer, data)
    if err != nil {
		fmt.Println("this is error"+err.Error());
		ctx.JSON(http.StatusNotFound,gin.H{"status":"html file invalid"})
        return
    }
	ctx.JSON(http.StatusOK,gin.H{"status":"Mail send successed"})

}