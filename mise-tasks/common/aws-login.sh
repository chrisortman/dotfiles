#!/usr/bin/env bash

#MISE description="Set up AWS CLI v1 with the awscli-login plugin in a virtualenv at ~/.virtualenvs/awscliv1"

set -e

VENV=~/.virtualenvs/awscliv1
PYTHON=$(mise which python)

echo "Creating virtualenv at $VENV using mise python ($PYTHON)..."
mkdir -p ~/.virtualenvs
"$PYTHON" -m venv "$VENV"

echo "Installing awscli and co-awscli-login..."
"$VENV/bin/pip" install awscli co-awscli-login

echo "Configuring awscli login plugin..."
"$VENV/bin/aws" configure set plugins.login awscli_login

AWS_LOGIN_CONFIG=~/.aws-login/config
if [ ! -f "$AWS_LOGIN_CONFIG" ]; then
  echo "Creating $AWS_LOGIN_CONFIG..."
  mkdir -p ~/.aws-login
  cat > "$AWS_LOGIN_CONFIG" <<EOF
[default]
ecp_endpoint_url = https://idp.uiowa.edu/idp/profile/SAML2/SOAP/ECP
username = $USER
factor = push
EOF
else
  echo "$AWS_LOGIN_CONFIG already exists, skipping."
fi

echo ""
echo "Done! Add this alias to your shell config:"
echo "  alias aws1=~/.virtualenvs/awscliv1/bin/aws"
