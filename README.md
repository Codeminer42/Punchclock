Punchclock
=========

A simple electronic punch clock to track hours spent on projects.

## Rails

This app uses Rails 4.0.0 and Postgres >= 9.1

## Installing

```console
$ git clone git@github.com:Codeminer42/punchclock.git
$ cd punchclock
$ cp config/database.yml.example config/database.yml
$ bundle install
$ bundle exec rake db:setup
```

### Postgree Notes
If something went wrong take a look on 
config/database.yml 
If necessary change username and/or host.

### Development

Run: 
```console 
$rake db:seed
```
And the following admin users will be created

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
$ bundle exec rails s
```

### Console

```console
$ bundle exec rails c
```

## Testing

This app uses Rspec, Factory Girl, Forgery and Faker to fake reality.

Please read [betterspecs.org](http://betterspecs.org/).

At first time:
```console
$ bundle exec rake db:migrate
$ bundle exec rake test:prepare
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
