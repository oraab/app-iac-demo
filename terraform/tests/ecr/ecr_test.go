package ecr

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"os"
	"strings"
	"testing"
)

func TestEcrCreation(t *testing.T) {
	appExampleDir := "../../examples/ecr"

	ecrOpts := createEcrOpts(t, appExampleDir)
	defer terraform.Destroy(t, ecrOpts)

	terraform.InitAndApply(t, ecrOpts)

}

func createEcrOpts(t *testing.T, terraformDir string) *terraform.Options {
	bucket := os.Getenv("TF_VAR_tf_state_bucket")
	dynamoDbTable := os.Getenv("TF_VAR_tf_state_lock")
	region := "us-east-1"
	stateKey := fmt.Sprintf("%s/%s/terraform.tfstate",t.Name(),random.UniqueId())

	return &terraform.Options{
		TerraformDir:             terraformDir,
		Vars: map[string]interface{}{
			"name": strings.ToLower(fmt.Sprintf("%s-%s",t.Name(),random.UniqueId())),
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