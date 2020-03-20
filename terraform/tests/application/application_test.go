package application

import (
	"fmt"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"strings"
	"testing"
	"time"
)

func TestApplication(t *testing.T) {
	appExampleDir := "../../examples/application"

	appOpts := createAppOpts(t, appExampleDir)
	defer terraform.Destroy(t, appOpts)

	terraform.InitAndApply(t, appOpts)

	validateApp(t, appOpts)
}

func createAppOpts(t *testing.T, terraformDir string) *terraform.Options {
	// TODO: replace bucket and dynmaoDbTable with env vars
	bucket := "app-iac-demo-state-2020-03-19"
	dynamoDbTable := "app-iac-demo-lock-2020-03-19"
	region := "us-east-1"
	stateKey := fmt.Sprintf("%s/%s/terraform.tfstate",t.Name(),random.UniqueId())

	return &terraform.Options{
		TerraformDir:             terraformDir,
		Vars: map[string]interface{}{
			"ami": "ami-0f1a497415643bcbd", // ubuntu 18.04 with k8s 1.16.2
			"environment": "staging",
			"min_size": 1,
			"max_size": 1,
			"internal": true,
		},
		MaxRetries: 3,
		TimeBetweenRetries: 5 * time.Second,
		RetryableTerraformErrors: map[string]string{
			"RequestError: send request failed": "Instance may still be initializing",
		},
		BackendConfig:            map[string]interface{}{
			"bucket": bucket,
			"key": stateKey,
			"region": region,
			"dynamodb_table": dynamoDbTable,
			"encrypt": true,
		},
	}
}

func validateApp(t *testing.T, appOpts *terraform.Options) {
	albDnsName := terraform.OutputRequired(t, appOpts, "alb_dns_name")
	url := fmt.Sprintf("http://%s",albDnsName)

	maxRetries := 10
	timeBetweenRetries := 10 * time.Second

	http_helper.HttpGetWithRetryWithCustomValidation(
		t,
		url,
		nil,
		maxRetries,
		timeBetweenRetries,
		func(status int, body string) bool {
			return status == 200 &&
				strings.Contains(body, "Hello, World")
		},
	)
}