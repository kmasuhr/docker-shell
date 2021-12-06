FROM ubuntu:latest

WORKDIR /root
ENV PROMPT_PREFIX=""
ARG DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /tmp/config && apt-get update \
    && apt-get install -y git curl binutils clang make apt-transport-https gnupg2 unzip software-properties-common \
    && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
    && apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"


# todo add docker cli && powershell
# docker-ce docker-ce-cli containerd
RUN  apt-get update && apt-get install -y wget nano htop tldr jq bat
#    && wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb \
#    && dpkg -i packages-microsoft-prod.deb \
#    && apt-get update \
#    && add-apt-repository universe \
#    && apt-get install -y powershell

ADD scripts/install-tools.sh /tmp/install-tools.sh
RUN /tmp/install-tools.sh

ADD config/ /tmp/config/
ADD scripts/ /tmp/scripts/

ENTRYPOINT /tmp/scripts/entrypoint.sh
CMD zsh
