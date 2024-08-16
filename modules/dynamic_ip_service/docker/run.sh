#!/bin/sh

# Variables
GIT_REPO_URL="https://github.com/mwgolden/site-to-site-vpn.git"
CLONE_DIR="/app/repo"
TERRAFORM_COMMAND="terraform plan"

# Clone the Git repository
git clone $GIT_REPO_URL $CLONE_DIR

# Change to the cloned directory
cd $CLONE_DIR

terraform init

# Run the Terraform command
$TERRAFORM_COMMAND "$@"
