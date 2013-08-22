Punckclock
=========

DESCRIPTION HERE...

## Rails

This app uses Rails 4.0.0 and Postgres >= 9.1

## Installing

```console
git clone git@github.com:Codeminer42/punchclock.git
cd punchclock
cp config/database.yml.example config/database.yml
bundle install
bundle exec rake db:setup
```

## Running

### Server

Run it on development mode using `thin`

```console
bundle exec rails s
```

### Console

```console
bundle exec rails c
```

## Testing

This app uses Rspec, Factory Girl, Forgery and Faker to fake reality.

Please read [betterspecs.org](http://betterspecs.org/).

Running tests:

```console
bundle exec rake spec
```


Running with [Guard](https://github.com/guard/guard-rspec):

```console
bundle exec guard
```

## Deploy

Givin errors to precompile assets must use this heroku add-on.

Please read [labs-user-env-compile](https://devcenter.heroku.com/articles/labs-user-env-compile)

```console
heroku labs:enable user-env-compile -a punchclock
```