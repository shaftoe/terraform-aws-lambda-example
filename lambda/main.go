package main

import (
	"fmt"

	"github.com/aws/aws-lambda-go/lambda"
)

func HandleRequest() {
	fmt.Println("Hello, world!")
}

func main() {
	lambda.Start(HandleRequest)
}
