package main

import (
	"log"
	"os"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/hashicorp/vault/api"
)

type payload struct {
	SampleData string `json:"sample_data"`
}

type secret struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

func HandleLambdaEvent(event payload) (secret, error) {
	client, err := api.NewClient(&api.Config{
		Address: "http://127.0.0.1:8200",
	})

	if err != nil {
		log.Fatal(err)
	}

	s, err := client.Logical().Read(os.Getenv("VAULT_SECRET_PATH"))
	if err != nil {
		log.Fatal(err)
	}

	data := s.Data["data"].(map[string]interface{})

	log.Print(data["username"])
	log.Print(data["password"])

	return secret{Username: data["username"].(string), Password: data["password"].(string)}, nil
}

func main() {
	lambda.Start(HandleLambdaEvent)
}
