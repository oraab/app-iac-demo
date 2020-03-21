package alb

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"os"
	"testing"
	"time"
)

func TestAlbWithRestrictedAccess(t *testing.T) {
	t.Parallel()
	albExampleDir := "../../examples/alb/internal-alb"

	testAlb(t, albExampleDir)
}

func TestAlbWithPublicAccess(t *testing.T) {
	t.Parallel()
	albExampleDir := "../../examples/alb/internet-facing-alb"

	testAlb(t, albExampleDir)
}

func testAlb(t *testing.T, exampleDir string) {
	albOpts := createAlbOpts(t, exampleDir)
	defer terraform.Destroy(t, albOpts)

	terraform.InitAndApply(t,albOpts)
}

func createAlbOpts(t *testing.T, terraformDir string) *terraform.Options {
	bucket := os.Getenv("TF_VAR_tf_state_bucket")
	dynamoDbTable := os.Getenv("TF_VAR_tf_state_lock")
	region := "us-east-1"
	stateKey := fmt.Sprintf("%s/%s/terraform.tfstate",t.Name(),random.UniqueId())

    return &terraform.Options{
		TerraformDir:             terraformDir,
		Vars: map[string]interface{}{
			"vpc_name": fmt.Sprintf("%s-%s-vpc",t.Name(),random.UniqueId()),
		},
		MaxRetries: 3,
		TimeBetweenRetries: 5 * time.Second,
		RetryableTerraformErrors: map[string]string{
			"RequestError: send request failed": "Instance may still be initializing",
			"Error locking state": "lock was not acquired yet",
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
