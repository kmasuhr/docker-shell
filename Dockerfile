FROM ubuntu:latest

WORKDIR /root
ENV PROMPT_PREFIX=""
ARG DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /tmp/config && apt-get update \
    && apt-get install -y git curl binutils clang make apt-transport-https gnupg2 unzip software-properties-common \
    && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list \
    && curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
    && apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip && ./aws/install && rm awscliv2.zip && rm -rf aws \
    && apt-get update && apt-get install -y wget nano htop tldr jq bat kubectl docker-ce docker-ce-cli containerd.io \
    && curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash \
    && export NVM_DIR="$HOME/.nvm" && echo $NVM_DIR \
    && . $NVM_DIR/nvm.sh \
    && wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get update \
    && add-apt-repository universe \
    && apt-get install -y powershell

RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl \
    && curl -LO "https://github.com/ahmetb/kubectx/releases/download/v0.9.1/kubectx" && curl -LO "https://github.com/ahmetb/kubectx/releases/download/v0.9.1/kubens" \
    && chmod +x ./kubectx ./kubens && mv ./kubectx /usr/local/bin/kubectx && mv ./kubens /usr/local/bin/kubens \
    && curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
    && curl -LO "https://releases.hashicorp.com/packer/1.7.0/packer_1.7.0_linux_amd64.zip" \
    && unzip packer_1.7.0_linux_amd64.zip && mv ./packer /usr/local/bin/packer

RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.1/zsh-in-docker.sh)" \
    && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k \
    && echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc \
    && git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    && mkdir -p /profile_copy && cp -R . /profile_copy \
    && curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash \
    && curl -L https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash \
    && wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.31.0/terragrunt_linux_arm64 -O terragrunt \
    && chmod +x terragrunt && mv ./terragrunt /usr/local/bin/terragrunt \
    && wget https://github.com/vmware-tanzu/velero/releases/download/v1.6.1/velero-v1.6.1-linux-amd64.tar.gz \
    && tar -xvzf velero-v1.6.1-linux-amd64.tar.gz && chmod +x velero-v1.6.1-linux-amd64/velero \
    && mv velero-v1.6.1-linux-amd64/velero /usr/local/bin/velero && rm -rf velero-v1.6.1-linux-amd64 \
    && wget https://github.com/derailed/k9s/releases/download/v0.24.10/k9s_v0.24.10_Linux_x86_64.tar.gz -O k9s.tar.gz \
    && mkdir k9s_out && tar -xzvf k9s.tar.gz -C ./k9s_out && mv ./k9s_out/k9s /usr/local/bin/k9s && rm -rf k9s_out && rm -rf k9s.tar.gz

ADD config/ /tmp/config/
ADD scripts/ /tmp/scripts/

ENTRYPOINT /tmp/scripts/entrypoint.sh
CMD zsh
