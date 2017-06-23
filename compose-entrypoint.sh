#!/usr/bin/env bash

rake db:create
rake db:schema:load
rake db:seed

./node_modules/.bin/webpack-dev-server --host 0.0.0.0 --config config/webpack.config.js &

exec "$@"
