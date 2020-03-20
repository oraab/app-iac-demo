package dns

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"testing"
)

func TestZoneCreation(t *testing.T) {
	t.Parallel()

	exampleDir := "../../examples/dns"
	dnsOpts := createDnsOpts(t, exampleDir)
    defer terraform.Destroy(t, dnsOpts)

	terraform.InitAndApply(t, dnsOpts)
}

func createDnsOpts(t *testing.T, terraformDir string) *terraform.Options {
	// TODO: replace bucket and dynmaoDbTable with env vars
	bucket := "app-iac-demo-state-2020-03-19"
	dynamoDbTable := "app-iac-demo-lock-2020-03-19"
	region := "us-east-1"
	stateKey := fmt.Sprintf("%s/%s/terraform.tfstate",t.Name(),random.UniqueId())

	return &terraform.Options{
		TerraformDir:             terraformDir,
		Vars: map[string]interface{}{
			"domain_name": fmt.Sprintf("%s.%s.com",t.Name(),random.UniqueId()),
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
