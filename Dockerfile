FROM ruby:3.1.2

LABEL MAINTAINER Codeminer42 <contact@codeminer42.com>

ARG USER_ID=1000
ARG GROUP_ID=1000

COPY Gemfile.lock .

ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
  && apt-get update \
  && apt-get install -y \
    build-essential \
    postgresql-client \
  && groupadd --gid ${GROUP_ID} app \
  && useradd --system --create-home --no-log-init --uid ${USER_ID} --gid ${GROUP_ID} --groups sudo app \
  && mkdir /var/app && chown -R app:app /var/app \
  && echo "app ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
  && gem install bundler -v $(tail -n 1 Gemfile.lock) \
  && chown -R app:app $BUNDLE_PATH \
  && sh ~/.nvm/nvm.sh install 16.13.1

USER app

WORKDIR /var/app
