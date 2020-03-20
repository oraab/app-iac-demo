package certificate

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"testing"
)

func TestCertificateCreation (t *testing.T) {
	certExampleDir := "../../examples/certificate"

	certOpts := createCertOpts(t, certExampleDir)
	defer terraform.Destroy(t, certOpts)

	terraform.InitAndApply(t, certOpts)

	// TODO: add validation for certificate creation

}

func createCertOpts(t *testing.T, terraformDir string) *terraform.Options {
	// TODO: replace bucket and dynmaoDbTable with env vars
	bucket := "app-iac-demo-state-2020-03-19"
	dynamoDbTable := "app-iac-demo-lock-2020-03-19"
	region := "us-east-1"
	stateKey := fmt.Sprintf("%s/%s/terraform.tfstate",t.Name(),random.UniqueId())

	return &terraform.Options{
		TerraformDir:             terraformDir,
		Vars: map[string]interface{}{
			"domain_name": "testing.cert.creation.com",
			"environment": "staging",
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