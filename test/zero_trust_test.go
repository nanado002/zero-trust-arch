package test

import (
	"testing"
	"strings"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestZeroTrustInfrastructure(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "../",
		Vars: map[string]interface{}{},
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": "us-east-1",
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Test outputs exist
	albDNS := terraform.Output(t, terraformOptions, "alb_dns_name")
	vpcID := terraform.Output(t, terraformOptions, "vpc_id")

	assert.True(t, strings.HasPrefix(albDNS, "zero-trust-alb-"))
	assert.True(t, strings.HasPrefix(vpcID, "vpc-"))
}
