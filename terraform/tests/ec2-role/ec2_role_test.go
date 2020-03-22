package ec2_role

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"os"
	"testing"
)

func TestInstanceProfileCreation(t *testing.T) {
	ec2RoleExampleDir := "../../examples/ec2-role"

	ec2RoleOpts := createEc2RoleOpts(t, ec2RoleExampleDir)
	defer terraform.Destroy(t, ec2RoleOpts)

	terraform.InitAndApply(t, ec2RoleOpts)

}

func createEc2RoleOpts(t *testing.T, terraformDir string) *terraform.Options {
	bucket := os.Getenv("TF_VAR_tf_state_bucket")
	dynamoDbTable := os.Getenv("TF_VAR_tf_state_lock")
	region := "us-east-1"
	stateKey := fmt.Sprintf("%s/%s/terraform.tfstate",t.Name(),random.UniqueId())

	return &terraform.Options{
		TerraformDir:             terraformDir,
		Vars: map[string]interface{}{
			"name": fmt.Sprintf("%s-%s",t.Name(),random.UniqueId()),
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
