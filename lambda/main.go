package main

import (
	"fmt"
	"os"

	"github.com/aws/aws-lambda-go/lambda"
)

func HandleRequest() {
	fmt.Printf("Hello, Serverless! Running version `%s`", os.Getenv("VERSION"))
}

func main() {
	lambda.Start(HandleRequest)
}
