package security_group

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"os"
	"testing"
)

func TestSecurityGroupWithIngressIp(t *testing.T) {
    t.Parallel()
	exampleDir := "../../examples/security-group/specific-ip-ingress"
	testSecurityGroup(t, exampleDir)
}

func TestSecurityGroupWithPublicAccess(t *testing.T) {
	t.Parallel()
	exampleDir := "../../examples/security-group/public-access"
	testSecurityGroup(t, exampleDir)
}

func testSecurityGroup(t *testing.T, exampleDir string) {
	securityGroupOpts := createSecurityGroupOpts(t, exampleDir)

	defer terraform.Destroy(t, securityGroupOpts)

	terraform.InitAndApply(t, securityGroupOpts)

	// TODO: find a way to validate the creation of ingress IP rule
}


func createSecurityGroupOpts(t *testing.T, terraformDir string) *terraform.Options {
	bucket := os.Getenv("TF_VAR_tf_state_bucket")
	dynamoDbTable := os.Getenv("TF_VAR_tf_state_lock")
	region := "us-east-1"
	stateKey := fmt.Sprintf("%s/%s/terraform.tfstate",t.Name(),random.UniqueId())

    return &terraform.Options{
		TerraformDir:             terraformDir,
		BackendConfig:            map[string]interface{}{
			"bucket": bucket,
			"region": region,
			"key": stateKey,
			"dynamodb_table": dynamoDbTable,
			"encrypt": true,
		},
	}
}

