Punchclock

A simple electronic punch clock to track hours spent on projects.

[![Build Status](http://gitlab42.com/Codeminer42/Punchclock/badges/master/build.svg)](http://gitlab42.com/Codeminer42/Punchclock/pipelines)

| [staging][1] | [production][2] |
|--------------|-----------------|

## Dependencies

```
Ruby 2.6.2
Rails 5.2.1
Postgres >= 9.1
```

## Installing

```console
$ git clone git@gitlab42.com:Codeminer42/Punchclock.git
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

## Deploy

[1]: http://punchclock-staging.herokuapp.com
[2]: http://punchclock.cm42.io/


# Miner Camp

### 1. Install gems and packages

    bundle install
    yarn install

### 2. Environment configuration
Copy the contents of the .env.sample file to the .env file and change it with the credentials of your local environment

    cp .env.sample .env

### 3. Create database

    rails db:create

### 4. Migrate database

    rails db:migrate

### 5. Populate database
Populate the database with the current offices

    rails db:seed

### Running the server

    rails s

### Running the test switch

    bundle exec rspec
