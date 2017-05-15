FROM jenkins:2.46.2

USER root

RUN apt-get update \
      && apt-get install -y apt-transport-https \
      ca-certificates \
      curl \
      software-properties-common \
      git-flow

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
      && add-apt-repository \ "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

RUN apt-get update \
      && apt-get install -y sudo docker-ce \
      && rm -rf /var/lib/apt/lists/* \
      && usermod -aG docker jenkins
      
RUN curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

RUN wget -qO- https://github.com/rancher/rancher-compose/releases/download/v0.12.3/rancher-compose-linux-amd64-v0.12.3.tar.gz | tar xvz -C /usr/local/bin
RUN mv /usr/local/bin/rancher-compose-v0.12.3/rancher-compose /usr/local/bin/rancher-compose
RUN rm -rf /usr/local/bin/rancher-compose-v0.12.3/
RUN chmod +x /usr/local/bin/rancher-compose

RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

USER jenkins
