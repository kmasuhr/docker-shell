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
    && apt-get update && apt-get install -y wget nano htop tldr jq bat kubectl terraform docker-ce docker-ce-cli containerd.io \
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
    && curl -sL https://aka.ms/InstallAzureCLIDeb | bash

RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.1/zsh-in-docker.sh)" \
    && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k \
    && echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc \
    && git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    && mkdir -p /profile_copy && cp -R . /profile_copy

ADD config/ /tmp/config/
ADD scripts/ /tmp/scripts/

ENTRYPOINT /tmp/scripts/entrypoint.sh
CMD zsh
