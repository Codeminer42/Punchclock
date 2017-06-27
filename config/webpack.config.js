// Example webpack configuration with asset fingerprinting in production.
'use strict';

var path = require('path');
var webpack = require('webpack');
var StatsPlugin = require('stats-webpack-plugin');

// must match config.webpack.dev_server.port
var devServerPort = 3808;

// set TARGET=production on the environment to add asset fingerprints
var production = process.env.TARGET === 'production';

var config = {
  entry: {
    application: "./webpack/application.js"
  },

  output: {
    // Build assets directly in to public/webpack/, let webpack know
    // that all webpacked assets start with webpack/
    // must match config.webpack.output_dir
    path: path.resolve(__dirname, '..', 'public', 'webpack'),
    filename: production ? '[name]-[chunkhash].js' : '[name].js',
    publicPath: "/webpack/",
  },

  module: {
    rules: [
      {
        test: /\.js?$/,
        exclude: [
          path.resolve(__dirname, "node_modules/")
        ],
        loader: "babel-loader",
        options: {
          presets: ["react", "es2015", "stage-0"]
        },
      }
    ]
  },

  resolve: {
    modules: [
      "node_modules",
      path.resolve(__dirname, "webpack")
    ],
    extensions: [".js", ".jsx"],
  },

  plugins: [
    // must match config.webpack.manifest_filename
    new StatsPlugin('manifest.json', {
      // We only need assetsByChunkName
      chunkModules: false,
      source: false,
      chunks: false,
      modules: false,
      assets: true
    })
  ]
};

if (production) {
  config.plugins.push(
    new webpack.NoErrorsPlugin(),
    new webpack.optimize.UglifyJsPlugin({
      compressor: { warnings: false },
      sourceMap: false
    }),
    new webpack.DefinePlugin({
      'process.env': { NODE_ENV: JSON.stringify('production') }
    }),
    new webpack.optimize.DedupePlugin()
  );
} else {
  config.devServer = {
    disableHostCheck: true,
    port: devServerPort,
    headers: { 'Access-Control-Allow-Origin': '*' }
  };

  config.output.publicPath = '//0.0.0.0:' + devServerPort + '/webpack/';

  // Source maps
  config.devtool = 'cheap-module-eval-source-map';
}

module.exports = config;
