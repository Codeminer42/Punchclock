# Punchclock

A simple electronic punch clock to track hours spent on projects.

[![Ruby](https://github.com/Codeminer42/Punchclock/actions/workflows/ruby.yml/badge.svg)](https://github.com/Codeminer42/Punchclock/actions/workflows/ruby.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/484d98c1af980b54a2db/maintainability)](https://codeclimate.com/github/Codeminer42/Punchclock/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/484d98c1af980b54a2db/test_coverage)](https://codeclimate.com/github/Codeminer42/Punchclock/test_coverage)

## Dependencies

```
Ruby 3.1
Rails 7.0
Postgres >= 13.7
Node 16.13.1
Yarn >= 1.22.19
```

## Installing

```console
$ git clone git@github.com:Codeminer42/Punchclock.git
$ cd Punchclock
$ Install Postgres
$ Install Redis
$ Install Yarn as a global dependency (npm i -g yarn@1.22.19)
$ bin/setup
```

## Database

After installation steps the following admin users will be created in database

1. An Admin User
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

To enable `guard-livereload`, you need to install the [LiveReload](https://chrome.google.com/webstore/detail/livereload/jnihajbhpnppcggbcgedagnkighmdlei) extension on your browser.

In another terminal, start Guard:

```
$ bundle exec guard
```

After that, start the extension on your browser. You'll see a browser connection browser on the terminal.

Freely make your changes and the page will be refreshed after you save it.

### Docker environment for development

Install the docker and docker compose plugin versions:

* Docker `~>v20.10`
* Docker compose plugin `~>v2.10`

```console
$ cp config/database.yml.example config/database.yml
$ docker compose build
$ docker compose run --rm app bundle install
$ docker compose run --rm app yarn install --frozen-lockfile
$ docker compose run --rm app bundle exec rake db:reset
$ docker compose run --rm app bundle exec rake db:create
```

#### Useful commands

Access Rails console:

```console
$ docker compose run --rm app rails c
```

If you want to run tests:
```console
$ docker compose run --rm app bundle exec rspec
```

Now run the servers:
```console
$ docker compose up
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

## Debugging

To debug this app, follow the following steps, for more details about debugging with pry, read the official documentation here: https://pry.github.io/ .
### Running with foreman

At the point of code that you want to debug, add:

```ruby
binding.remote_pry
```

Run you application, the app should stop at the point that you added `binding.remote_pry`.

In you terminal, run:

```console
$ bundle exec pry-remote
```

Now you will get the piece of code where you can debug.

### Running with rails server

At the point of code that you want to debug, add:

```ruby
binding.pry
```

Run you application, the app should stop at the point that you added `binding.pry` and you will get the piece of code where you can debug.

### Debugguing a test

At the point of code that you want to debug, add:

```ruby
binding.pry
```
In you terminal, run:

```console
$ bundle exec rspec <PATH_TO_FILE>
```

### Exiting the debug mode

To exit the `pry` console, type:

To hard exit:

```console
-> !!!
```

To soft exit:

```console
-> exit
```

License
-------
Copyright 2013-2021, Codeminer 42.

Punchclock is made available under the Affero GPL license version 3, see
[LICENSE.txt](https://github.com/Codeminer42/cm42-central/blob/master/LICENCE.txt).
