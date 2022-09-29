FROM ruby:3.1.2

LABEL MAINTAINER Codeminer42 <contact@codeminer42.com>

ARG USER_ID=1000
ARG GROUP_ID=1000

COPY Gemfile.lock .

ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

RUN apt-get update \
  && apt-get install -y \
    build-essential \
    postgresql-client \
  && groupadd --gid ${GROUP_ID} app \
  && useradd --system --create-home --no-log-init --uid ${USER_ID} --gid ${GROUP_ID} --groups sudo app \
  && mkdir /var/app && chown -R app:app /var/app \
  && echo "app ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
  && gem install bundler -v $(tail -n 1 Gemfile.lock) \
  && chown -R app:app $BUNDLE_PATH

USER app

# Install node for app user
ENV NVM_DIR /home/app/.nvm
ENV NODE_VERSION 16.13.1
ENV YARN_VERSION 1.22.19
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
  && . ~/.nvm/nvm.sh \
  && nvm install ${NODE_VERSION} \
  && nvm alias default ${NODE_VERSION} \
  && nvm use default \
  && npm install -g yarn@${YARN_VERSION}
ENV NODE_PATH ${NVM_DIR}/versions/node/v${NODE_VERSION}/lib/node_modules
ENV PATH ${NVM_DIR}/versions/node/v${NODE_VERSION}/bin:${PATH}

WORKDIR /var/app
