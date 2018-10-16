FROM codeminer42/ci-ruby:2.5

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
        curl \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        nodejs \
        build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get -yqq update \
    && apt-get install -yqq --no-install-recommends \
        google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ADD Gemfile Gemfile.lock package.json /app/
RUN gem update bundler --pre
RUN bundle install
RUN npm install

ADD . /app

EXPOSE 3000 3808
