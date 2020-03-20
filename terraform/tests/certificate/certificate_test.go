package certificate

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"strings"
	"testing"
)

func TestCertificateCreation (t *testing.T) {
	zoneExampleDir := "../../examples/dns"
	certExampleDir := "../../examples/certificate"

	domainName := strings.ToLower(fmt.Sprintf("%s.%s.com",t.Name(),random.UniqueId()))

	dnsOpts := createDnsOpts(t, zoneExampleDir, domainName)
	certOpts := createCertOpts(t, certExampleDir, domainName)
	defer terraform.Destroy(t, certOpts)
	defer terraform.Destroy(t, dnsOpts)

	terraform.InitAndApply(t, dnsOpts)
	terraform.InitAndApply(t, certOpts)

	// TODO: add validation for certificate creation

}

func createDnsOpts(t *testing.T, terraformDir string, domainName string) *terraform.Options {
	t.Logf("domain_name: %s",domainName)
	return &terraform.Options{
		TerraformDir: terraformDir,
		Vars:  map[string]interface{}{
			"domain_name": domainName,
		},
		BackendConfig: getBackendConfig(t),
	}
}
func createCertOpts(t *testing.T, terraformDir string, domainName string) *terraform.Options {
   t.Logf("domain_name: %s", domainName)

	return &terraform.Options{
		TerraformDir:             terraformDir,
		Vars: map[string]interface{}{
			"domain_name": domainName,
			"environment": "staging",
		},
		BackendConfig: getBackendConfig(t),
	}
}

func getBackendConfig(t *testing.T) map[string]interface{}{
	// TODO: replace bucket and dynmaoDbTable with env vars
	bucket := "app-iac-demo-state-2020-03-19"
	dynamoDbTable := "app-iac-demo-lock-2020-03-19"
	region := "us-east-1"
	stateKey := fmt.Sprintf("%s/%s/terraform.tfstate",t.Name(),random.UniqueId())

	return map[string]interface{}{
		"bucket": bucket,
		"key": stateKey,
		"region": region,
		"dynamodb_table": dynamoDbTable,
		"encrypt": true,
	}
}