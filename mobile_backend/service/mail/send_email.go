package mail

import (
	"bytes"
	"fmt"
	"html/template"

	// "mobile_backend/service/mail"
	"net/smtp"

	"github.com/gin-gonic/gin"
)
  
type Page1 struct {
    Title   string
    Heading string
    Message string
}
  func SendEmail(ctx * gin.Context) {
	tmpl, err := template.ParseFiles("template/index.tmpl")
    if err != nil {
		fmt.Println("this is error"+err.Error());
        return
    }

    // Dữ liệu cho template
    data := Page1{
        Title:   "Go HTML Template Example",
        Heading: "Hello from Go!",
        Message: "This is a simple HTML page served by a Go web server.",
    }
	var body bytes.Buffer

	mimeHeaders := "MIME-version: 1.0;\nContent-Type: text/html; charset=\"UTF-8\";\n\n"
	body.Write([]byte(fmt.Sprintf("Subject: This is a test subject \n%s\n\n", mimeHeaders)))

    // Hiển thị template với dữ liệu đã cung cấp
    err = tmpl.Execute(&body, data)
    if err != nil {
		fmt.Println("this is error"+err.Error());
        return
    }
	// Sender data.
	from := "congminhptit0511@gmail.com"
	password := "unzi iciu cony lznk"
  
	// Receiver email address.
	to := []string{
	  "congminhptit0511@gmail.com",
	}
  
	// smtp server configuration.
	smtpHost := "smtp.gmail.com"
	smtpPort := "587"
  
	// Message.
	// message := []byte("This is a test email message.")
	
	// Authentication.
	auth := smtp.PlainAuth("", from, password, smtpHost)
	
	// Sending email.

	err = smtp.SendMail(smtpHost+":"+smtpPort, auth, from, to, body.Bytes())
	if err != nil {
	  fmt.Println(err)
	  return
	}
	fmt.Println("Email Sent Successfully!")
  }
  