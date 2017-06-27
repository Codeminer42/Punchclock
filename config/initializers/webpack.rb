Punchclock::Application.configure do
  config.webpack.dev_server.manifest_host = ENV.fetch('WEBPACK_REMOTE_HOST', 'localhost')
  config.webpack.dev_server.manifest_port = ENV.fetch('WEBPACK_REMOTE_PORT', 3808)
end
