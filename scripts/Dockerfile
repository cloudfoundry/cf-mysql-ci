FROM ubuntu:trusty
MAINTAINER https://github.com/cloudfoundry/cf-mysql-release

ENV DEBIAN_FRONTEND=noninteractive

ARG BBL_GIT_TAG
ARG BBL6_GIT_TAG
ARG BOSH_CLI_VERSION
ARG CREDHUB_CLI_VERSION
ARG TERRAFORM_VERSION

# libmysqlclient-dev is used for pre-packaging cf-mysql-broker
# libfontconfig1-dev etc. are required by phantomjs
# nodejs, npm and libicu52 are for switchboard ui
RUN \
      apt-get update && \
      apt-get -y install --fix-missing \
            build-essential \
            curl \
            git \
            libreadline6 \
            libreadline6-dev\
            wget \
            unzip \
            libmysqlclient-dev \
            nodejs \
            npm \
            libicu52 \
            libfontconfig1-dev libfreetype6 libssl-dev libpng-dev libjpeg-dev \
            mysql-client \
            python-dev \
            apt-transport-https \
            software-properties-common \
            aria2 \
      && \
      apt-get clean

# Install Java 8
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y  software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get clean

RUN \
    apt-add-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -cs)-backports universe" \
    && apt-get -qq update \
    && apt-get -t $(lsb_release -cs)-backports install shellcheck

RUN \
    apt-add-repository "deb https://packages.cloud.google.com/apt cloud-sdk-$(lsb_release -c -s) main" \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && apt-get update \
    && apt-get -y install google-cloud-sdk

# Install cf cli
RUN \
    wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | apt-key add - \
    && echo "deb http://packages.cloudfoundry.org/debian stable main" | tee /etc/apt/sources.list.d/cloudfoundry-cli.list \
    && apt-get update \
    && apt-get -y install cf-cli

# Alias nodejs as node for switchboard ui
RUN ln -s /usr/bin/nodejs /usr/bin/node

RUN \
    apt-get -y install software-properties-common \
    && apt-add-repository ppa:brightbox/ruby-ng \
    && apt-get update \
    && apt-get -y install ruby2.3 ruby2.3-dev zlib1g-dev

# Install bosh cli
RUN \
  wget -q "https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-${BOSH_CLI_VERSION}-linux-amd64" -O /usr/local/bin/bosh && \
  chmod +x /usr/local/bin/bosh

# Phantomjs is used by switchboard ui tests and dashboard acceptance tests
RUN wget https://github.com/Pyppe/phantomjs2.0-ubuntu14.04x64/raw/master/bin/phantomjs && \
          chmod +x phantomjs && \
          mv phantomjs /usr/bin/phantomjs

# Install Percona Server 5.7
RUN \
  wget https://repo.percona.com/apt/percona-release_latest.generic_all.deb && \
  dpkg -i percona-release_latest.generic_all.deb && \
  percona-release setup ps57 && \
  apt-get update && \
  apt-get -y install percona-server-server-5.7

# Install go
RUN curl https://dl.google.com/go/go1.11.6.linux-amd64.tar.gz | tar xvz -C /usr/local/

# Add golang environment variables
RUN mkdir -p $HOME/go
ENV GOPATH $HOME/go
ENV PATH $PATH:$GOPATH/bin

# Install ginkgo and gomega
RUN go get github.com/onsi/ginkgo/ginkgo
RUN go get github.com/onsi/gomega

# Install spiff
RUN wget -O /tmp/spiff.zip https://github.com/cloudfoundry-incubator/spiff/releases/download/v1.0.7/spiff_linux_amd64.zip
RUN unzip /tmp/spiff.zip -d /tmp/ && mv /tmp/spiff $GOPATH/bin/

# Add workspace directory
RUN mkdir -p /root/workspace && ln -s /root/workspace /workspace

# Tell ssh to ignore fingerprints
RUN mkdir -p /root/.ssh
RUN echo "Host * \n\tStrictHostKeyChecking no \n\tUserKnownHostsFile=/dev/null" >> /root/.ssh/config

# Install aws cli
RUN wget https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py && \
          python /tmp/get-pip.py && \
          rm /tmp/get-pip.py && \
          pip install awscli

# Install consul
RUN \
  wget -q https://releases.hashicorp.com/consul/0.7.4/consul_0.7.4_linux_amd64.zip -P /tmp/ && \
  unzip /tmp/consul_0.7.4_linux_amd64.zip -d /usr/local/bin && \
  rm /tmp/consul_0.7.4_linux_amd64.zip

# Install gems
RUN gem install bundler -v 1.17.3 --no-rdoc --no-ri
RUN gem install gorgeous --no-rdoc --no-ri

# Install terraform
RUN wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
  --quiet \
  --output-document /tmp/terraform.zip && \
  unzip /tmp/terraform.zip -d /usr/local/bin/ && \
  chmod +x /usr/local/bin/terraform && \
  rm /tmp/terraform.zip

RUN wget "https://github.com/cloudfoundry/bosh-bootloader/releases/download/${BBL_GIT_TAG}/bbl-${BBL_GIT_TAG}_linux_x86-64" \
      -O /usr/local/bin/bbl && \
      chmod +x /usr/local/bin/bbl

# Temporarily install bbl 6 and bbl 4 as separate binaries
# until we can get all envs moved to bbl 6.
RUN wget "https://github.com/cloudfoundry/bosh-bootloader/releases/download/${BBL6_GIT_TAG}/bbl-${BBL6_GIT_TAG}_linux_x86-64" \
      -O /usr/local/bin/bbl6 && \
      chmod +x /usr/local/bin/bbl6

# Install credhub cli
RUN wget -O - "https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/${CREDHUB_CLI_VERSION}/credhub-linux-${CREDHUB_CLI_VERSION}.tgz" \
    | tar -xzv -C /usr/local/bin/

# Install jq 1.5
RUN wget -O /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 && \
  chmod +x /usr/local/bin/jq
