package vpc

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"os"
	"strings"
	"testing"
)

func TestVpcWithDefaultValues(t *testing.T) {
	vpcExampleDir := "../../examples/vpc/provided_cidr_blocks"

	vpcOpts := createVpcOptsWithDefaults(t, vpcExampleDir)
	defer terraform.Destroy(t, vpcOpts)

	terraform.InitAndApply(t, vpcOpts)

	validateVpcWithDefaults(t, vpcOpts)
}

func createVpcOptsWithDefaults(t *testing.T,
	terraformDir string) *terraform.Options {
	bucket := os.Getenv("TF_VAR_tf_state_bucket")
	dynamoDbTable := os.Getenv("TF_VAR_tf_state_lock")
	region := "us-east-1"
	stateKey := fmt.Sprintf("%s/%s/terraform.tfstate",t.Name(),random.UniqueId())

	return &terraform.Options{
		TerraformDir:             terraformDir,
		Vars: map[string]interface{}{
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

func validateVpcWithDefaults(t *testing.T,
	vpcOpts *terraform.Options) {
	vpcId := terraform.OutputRequired(t, vpcOpts, "vpc_id")
	subnetIds := terraform.OutputRequired(t, vpcOpts, "subnet_ids")
	vpcName := "test_vpc_name-staging"
	vpc := aws.GetVpcById(t, vpcId, "us-east-1")
	if vpc.Name != vpcName {
		t.Errorf("provided VPC name %s was not the expected VPC name %s",vpc.Name,vpcName)
	}
	for _, subnet := range vpc.Subnets {
		if ! strings.Contains(subnetIds,subnet.Id) {
			t.Errorf("provided subnet ID %s does not exist in output list", subnet.Id)
		}
	}

}