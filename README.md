Punchclock
=========

A simple electronic punch clock to track hours spent on projects.

[![Build Status](http://gitlab42.com/Codeminer42/Punchclock/badges/master/build.svg)](http://gitlab42.com/Codeminer42/Punchclock/pipelines)

| [staging][1] | [production][2] |
|--------------|-----------------|

## Dependencies

```
Ruby 2.4.1
Rails 4.2.8
Postgres >= 9.1
```

## Installing

```console
$ git clone git@gitlab42.com:Codeminer42/Punchclock.git
$ cd Punchclock
$ bin/setup
$ cp .env.example .env
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

## Running

### Server

Run it on development mode using `thin`

```console
$ foreman start -f Procfile.dev
```

### Docker

```console
$ cp config/database.yml.example config/database.yml
$ docker-compose up -d
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

Givin errors to precompile assets must use this heroku add-on.

Please read [labs-user-env-compile](https://devcenter.heroku.com/articles/labs-user-env-compile)

```console
$ heroku labs:enable user-env-compile -a punchclock
```

[1]: http://punchclock-staging.herokuapp.com
[2]: http://punchclock.cm42.io/
