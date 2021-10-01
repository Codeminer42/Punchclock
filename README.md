# Punchclock

A simple electronic punch clock to track hours spent on projects.

[![Ruby](https://github.com/Codeminer42/Punchclock/actions/workflows/ruby.yml/badge.svg)](https://github.com/Codeminer42/Punchclock/actions/workflows/ruby.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/484d98c1af980b54a2db/maintainability)](https://codeclimate.com/github/Codeminer42/Punchclock/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/484d98c1af980b54a2db/test_coverage)](https://codeclimate.com/github/Codeminer42/Punchclock/test_coverage)

## Dependencies

```
Ruby 2.7.1
Rails 6.0.3
Postgres >= 9.1
```

## Installing

```console
$ git clone git@github.com:Codeminer42/Punchclock.git
$ cd Punchclock
$ cp .env.example .env
$ Install Postgres
$ Install Redis
$ Install NodeJS
$ bin/setup
```

## Database

After installation steps the following admin users will be created in database

1. Super Admin User
```
E-mail:   super@codeminer42.com
Password: password
```

2. A Admin User
```
E-mail:   admin@codeminer42.com
Password: password
```

## Adding new Javascript

Javascript with ES6 syntax should be compiled by webpack instead of sprockets as of now. The Javascript may work in development mode in modern browsers, but it will break in production mode, be aware.

## Running

### Server

Run it on development mode using `thin`

```console
$ foreman start -f Procfile.dev
```

### Docker environment for development

```console
$ cp .env.example .env
$ docker-compose build
$ docker-compose run --rm runner bundle install
$ docker-compose run --rm runner yarn install --frozen-lockfile
$ docker-compose run --rm runner bundle exec rake db:reset
$ docker-compose run --rm runner_tests bundle exec rake db:create
```

If you want to run tests:
```console
$ docker-compose run --rm runner_tests bundle exec rspec
```

Now run the servers:
```console
$ docker-compose up
```

## Testing

This app uses RSpec, Factory Girl, Forgery and Faker to fake reality.
Please read [betterspecs.org](http://betterspecs.org/).

At first time:
```console
$ bundle exec rake db:migrate
```

Running tests:

```console
$ bundle exec rake spec
```

Running with [Guard](https://github.com/guard/guard-rspec):

```console
$ bundle exec guard
```

License
-------
Copyright 2013-2021, Codeminer 42.

Punchclock is made available under the Affero GPL license version 3, see
[LICENSE.txt](https://github.com/Codeminer42/cm42-central/blob/master/LICENCE.txt).
