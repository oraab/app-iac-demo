package certificate

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"os"
	"strings"
	"testing"
	"time"
)

func TestCertificateCreation (t *testing.T) {
	zoneExampleDir := "../../examples/dns"
	certExampleDir := "../../examples/certificate"

	dnsOpts := createDnsOpts(t, zoneExampleDir)
	certOpts := createCertOpts(t, certExampleDir)
	defer terraform.Destroy(t, certOpts)
	defer terraform.Destroy(t, dnsOpts)

	terraform.InitAndApply(t, dnsOpts)
	terraform.InitAndApply(t, certOpts)

}

/*
 this test is not reproducible as it is due to the nature of certificate provisioning - replace the domain_name
 below with another registered domain_name to reproduce
*/
func createDnsOpts(t *testing.T, terraformDir string) *terraform.Options {
	return &terraform.Options{
		TerraformDir: terraformDir,
		Vars:  map[string]interface{}{
			"domain_name": strings.ToLower(fmt.Sprintf("%s.%s",t.Name(),random.UniqueId())),
		},
		BackendConfig: getBackendConfig(t),
	}
}

/*
 this test is not reproducible as it is due to the nature of certificate provisioning - replace the domain_name
 below with another registered domain_name to reproduce
*/
func createCertOpts(t *testing.T, terraformDir string) *terraform.Options {

	return &terraform.Options{
		TerraformDir:             terraformDir,
		Vars: map[string]interface{}{
			"domain_name": "testing-placeholder.xyz",
			"environment": "staging",
		},
		MaxRetries: 3,
		TimeBetweenRetries: 5 * time.Second,
		RetryableTerraformErrors: map[string]string{
			"RequestError: send request failed": "Instance may still be initializing",
			"Error locking state": "lock was not acquired yet",
		},
		BackendConfig: getBackendConfig(t),
	}
}

func getBackendConfig(t *testing.T) map[string]interface{}{
	bucket := os.Getenv("TF_VAR_tf_state_bucket")
	dynamoDbTable := os.Getenv("TF_VAR_tf_state_lock")
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