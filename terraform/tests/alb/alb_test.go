package alb

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"testing"
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
	// TODO: replace bucket and dynmaoDbTable with env vars
	bucket := "app-iac-demo-state-2020-03-19"
	dynamoDbTable := "app-iac-demo-lock-2020-03-19"
	region := "us-east-1"
	stateKey := fmt.Sprintf("%s/%s/terraform.tfstate",t.Name(),random.UniqueId())

    return &terraform.Options{
		TerraformDir:             terraformDir,
		Vars: map[string]interface{}{
			"vpc_name": fmt.Sprintf("%s-%s-vpc",t.Name(),random.UniqueId()),
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
