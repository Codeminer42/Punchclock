FROM codeminer42/ci-ruby:2.7

LABEL MAINTAINER Codeminer42 <contact@codeminer42.com>

ENV DEBIAN_FRONTED=noninteractive

# On change this settings, check the state on "before_script" in .gitlab-ci.yml
RUN apt-get update && apt-get install -y \
  openssh-server \
  sudo \
  build-essential \
  ruby-dev \
  postgresql-client \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# SSH config
RUN mkdir /var/run/sshd \
  && sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
  && echo "export VISIBLE=now" >> /etc/profile \
  && echo 'root:root' | chpasswd
ENV NOTVISIBLE "in users profile"

# ADD an user
RUN adduser --disabled-password --gecos '' devel \
  && usermod -a -G sudo devel \
  && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
  && echo 'devel:devel' | chpasswd

# SETTINGS EQUALS TO CI
RUN ln -nfs /usr/lib/x86_64-linux-gnu/libssl.so.1.1 /usr/lib/x86_64-linux-gnu/libssl.so \
  && npm install -g yarn

ENV HOME=/home/devel
ENV APP=/var/www/app
ENV BUNDLE_PATH=/bundle/vendor
ENV GEM_HOME=${BUNDLE_PATH}
ENV PATH=${PATH}:${BUNDLE_PATH}/bin

ENV RAILS_LOG_TO_STDOUT true

RUN mkdir -p ${HOME} && \
  chown -R devel:devel ${HOME} && \
  mkdir -p ${APP} && \
  chown -R devel:devel ${APP} && \
  mkdir -p ${BUNDLE_PATH} && \
  chown -R devel:devel /bundle

USER devel:devel
WORKDIR $APP

RUN gem install bundler -v 2.1.4

EXPOSE 3000

CMD ["/usr/bin/sudo", "/usr/sbin/sshd", "-D"]
