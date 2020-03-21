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

func TestVpcWithProvidedValues(t *testing.T) {
	vpcName := fmt.Sprintf("%s-%s-vpc",t.Name(),random.UniqueId())
	vpcCidrBlock := "10.10.0.0"
	mainSubnetCidrBlock := "10.10.10.0"
	alternateSubnetCidrBlock := "10.10.11.0"
	vpcExampleDir := "../../examples/vpc/provided_cidr_blocks"

	vpcOpts := createVpcOpts(t, vpcExampleDir, vpcName, vpcCidrBlock, mainSubnetCidrBlock, alternateSubnetCidrBlock)
	defer terraform.Destroy(t, vpcOpts)

	terraform.InitAndApply(t, vpcOpts)

	validateVpc(t, vpcOpts, vpcName, vpcCidrBlock, mainSubnetCidrBlock, alternateSubnetCidrBlock)
}

func createVpcOpts(t *testing.T,
	               terraformDir string,
	               vpcName string,
	               vpcCidrBlock string,
	               mainSubnetCidrBlock string,
	               alternateSubnetCidrBlock string) *terraform.Options {
	bucket := os.Getenv("TF_VAR_tf_state_bucket")
	dynamoDbTable := os.Getenv("TF_VAR_tf_state_lock")
	region := "us-east-1"
	stateKey := fmt.Sprintf("%s/%s/terraform.tfstate",t.Name(),random.UniqueId())

	return &terraform.Options{
		TerraformDir:             terraformDir,
		Vars: map[string]interface{}{
			"vpc_name": vpcName,
			"vpc_cidr_block": vpcCidrBlock,
			"main_subnet_cidr_block": mainSubnetCidrBlock,
			"alternate_az_subnet_cidr_block": alternateSubnetCidrBlock,
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

func validateVpc(t *testing.T,
	             vpcOpts *terraform.Options,
	             vpcName string,
	             vpcCidrBlock string,
	             mainSubnetCidrBlock string,
	             alternateSubnetCidrBlock string) {
	vpcId := terraform.OutputRequired(t, vpcOpts, "vpc_id")
	subnetIds := terraform.OutputRequired(t, vpcOpts, "subnet_ids")
	vpc := aws.GetVpcById(t, vpcId, "us-east-1")
	if vpc.Name != fmt.Sprintf("%s-staging",vpcName) {
		t.Errorf("provided VPC name %s was not the expected VPC name %s",vpc.Name,vpcName)
	}
	for _, subnet := range vpc.Subnets {
		if ! strings.Contains(subnetIds,subnet.Id) {
			t.Errorf("provided subnet ID %s does not exist in output list", subnet.Id)
		}
	}

}