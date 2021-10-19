#!/usr/bin/env bash

TERRAFORM_VERSION=1.0.9
TERRAGRUNT_VERSION=0.35.3
VELERO_VERSION=1.7.0
K9S_VERSION=0.24.15
PACKER_VERSION=1.7.6
HELM_VERSION=3.7.0
KUBECTL_VERSION=1.21.2
KUBECTX_VERSION=0.9.4
AZURE_CLI_VERSION=2.29.0
ANSIBLE_AZURE_COLLECTION_VERSION=1.9.0
ANSIBLE_VERSION=2.10.15
PEXPECT_VERSION=4.8.0
VIRTUALENV_VERSION=20.8.1
YAMLLINT_VERSION=1.26.3
ARGOCD_VERSION=2.1.3

export DEBIAN_FRONTEND=noninteractive
echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

BOOTSTRAP_TMP_DIR=/tmp/bootstrap
mkdir -p "${BOOTSTRAP_TMP_DIR}"
cd "${BOOTSTRAP_TMP_DIR}" || exit

apt-get update \
&& apt-get install --no-install-recommends -y \
    python3-pip \
    curl \
    jq \
    unzip \
    zip \
    gcc \
    python3-dev \
    iputils-ping \
    libunwind8 \
    netcat \
    gnupg \
    software-properties-common \
    build-essential \
    wget \
    xz-utils \
&& pip3 --no-cache-dir install \
    ansible-base==${ANSIBLE_VERSION} \
    pexpect==${PEXPECT_VERSION} \
    virtualenv==${VIRTUALENV_VERSION} \
    yamllint==${YAMLLINT_VERSION}

# Prepare ZSH
sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.1/zsh-in-docker.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
mkdir -p /profile_copy && cp -R . /profile_copy

# Install terraform
curl -L https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
      -o terraform.zip \
    && unzip terraform.zip \
    && chmod +x terraform \
    && mv terraform /usr/local/bin/terraform \
    && rm -rf terraform.zip

# Install terraform && terragrunt
curl -L "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64" \
      -o /usr/local/bin/terragrunt
chmod +x /usr/local/bin/terragrunt

# Install velero
wget "https://github.com/vmware-tanzu/velero/releases/download/v${VELERO_VERSION}/velero-v${VELERO_VERSION}-linux-amd64.tar.gz"
tar -xvzf "velero-v${VELERO_VERSION}-linux-amd64.tar.gz"
chmod +x "velero-v${VELERO_VERSION}-linux-amd64/velero"
mv "velero-v${VELERO_VERSION}-linux-amd64/velero" /usr/local/bin/velero
rm -rf "velero-v${VELERO_VERSION}-linux-amd64"

# Install argo cli
wget "https://github.com/argoproj/argo-cd/releases/download/v${ARGOCD_VERSION}/argocd-linux-amd64"
chmod +x "argocd-linux-amd64" && mv argocd-linux-amd64 /usr/local/bin/argocd

# Download and install Kubectl
curl -sLk "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
      -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

# Install kubectx and kubens
curl -LO "https://github.com/ahmetb/kubectx/releases/download/v${KUBECTX_VERSION}/kubectx"
curl -LO "https://github.com/ahmetb/kubectx/releases/download/v${KUBECTX_VERSION}/kubens"
chmod +x ./kubectx ./kubens && mv ./kubectx /usr/local/bin/kubectx && mv ./kubens /usr/local/bin/kubens \

# Install K9S
wget "https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_x86_64.tar.gz" -O k9s.tar.gz
mkdir k9s_out && tar -xzvf k9s.tar.gz -C ./k9s_out && mv ./k9s_out/k9s /usr/local/bin/k9s
rm -rf k9s_out && rm -rf k9s.tar.gz

# Install Packer
curl -LsO "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip" \
&& unzip packer_"${PACKER_VERSION}"_linux_amd64.zip \
&& mv packer /usr/local/bin/packer \
&& rm -rf packer_"${PACKER_VERSION}"_linux_amd64.zip

# Download and install Helm
curl -sLOk "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" && \
    tar -xf helm-v"${HELM_VERSION}"-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    rm -rf helm-v"${HELM_VERSION}"-linux-amd64.tar.gz

# Azure-CLI
# shellcheck disable=SC1091
pip3 --no-cache-dir install -r https://raw.githubusercontent.com/ansible-collections/azure/v${ANSIBLE_AZURE_COLLECTION_VERSION}/requirements-azure.txt \
&& virtualenv /opt/azure-cli \
&& . /opt/azure-cli/bin/activate \
&& pip3 --no-cache-dir install azure-cli==${AZURE_CLI_VERSION} \
&& deactivate \
&& ln -s /opt/azure-cli/bin/az /usr/local/bin/az
