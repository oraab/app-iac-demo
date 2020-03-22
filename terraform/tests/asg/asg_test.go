package asg

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"os"
	"testing"
	"time"
)

func TestAsgWithLockedMinMaxInstances(t *testing.T) {
	albExampleDir := "../../examples/alb/internal-alb"
	asgExampleDir := "../../examples/asg/locked_min_max_instances"

	albOpts := createAlbOpts(t, albExampleDir)
	asgOpts := createAsgOpts(t, asgExampleDir)

	defer terraform.Destroy(t, asgOpts)
	defer terraform.Destroy(t, albOpts)

	terraform.InitAndApply(t, albOpts)
	terraform.InitAndApply(t, asgOpts)

}

func createAlbOpts(t *testing.T, terraformDir string) *terraform.Options {

	return &terraform.Options{
		TerraformDir:             terraformDir,
		Vars: map[string]interface{}{
		  "vpc_name": fmt.Sprintf("%s-%s",t.Name(),random.UniqueId()),
		  "internal": true,
		  "name": fmt.Sprintf("test-%s",random.UniqueId()),
		  "ingress_cidr_block": "0.0.0.0/0",
		},
		BackendConfig:   getBackendConfig(t),
	}
}

func createAsgOpts(t *testing.T, terraformDir string) *terraform.Options {

	return &terraform.Options{
		TerraformDir:             terraformDir,
		MaxRetries: 3,
		TimeBetweenRetries: 5 * time.Second,
		RetryableTerraformErrors: map[string]string{
			"RequestError: send request failed": "Instance may still be initializing",
			"Error locking state": "lock was not acquired yet",
		},
		Vars: map[string]interface{}{
			"role_name": fmt.Sprintf("%s-%s",t.Name(),random.UniqueId()),
			"environment": fmt.Sprintf("%s-%s",t.Name(),random.UniqueId()),
		},
		BackendConfig:  getBackendConfig(t),
	}

}

func getBackendConfig(t *testing.T) map[string]interface{} {
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
