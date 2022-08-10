#!/usr/bin/env bash

PACKER_VERSION=$(packer -v)
TERRAFORM_VERSION=$(terraform version | head -1 | cut -d " " -f2)
ANSIBLE_VERSION=$(ansible --version | head -1 | cut -d " " -f 3 | cut -d ] -f1)
KUBECTL_VERSION=$(kubectl version --short 2>/dev/null | head -1 | cut -d " " -f 3)
HELM_VERSION=$(helm version --short)

echo ">> BUILD SHELL <<"
echo ""
echo "-----------------"
echo " Installed Tools"
echo "-----------------"
echo "ansible: $ANSIBLE_VERSION"
echo "terraform: $TERRAFORM_VERSION"
echo "packer: $PACKER_VERSION"
echo "kubectl: $KUBECTL_VERSION"
echo "helm: $HELM_VERSION"
echo ""
echo "-----------------"
echo "User: $(whoami) [$(id -u):$(id -g)]"
echo "-----------------"
echo ""

rsync -av --exclude=. "$PWD/.home/" ~

if [ -f ~/.env ]; then
  echo ""
  echo ".env file found."
  dos2unix -q ~/.env
  for line in $(cat ~/.env | grep -v '^#' | grep -v '^[[:space:]]*$'); do
    export "$(eval echo $line)"
  done
fi

eval "$@"
