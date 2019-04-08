const path = require('path');
const CopyWebpackPlugin = require('copy-webpack-plugin');

var BUILD_DIR = path.resolve(__dirname, "builds", "web");
var APP_DIR = path.resolve(__dirname, 'web');
var SRC_DIR = path.resolve(APP_DIR, 'src');
var PUBLIC_DIR = path.resolve(APP_DIR, 'public');

module.exports = {
  devtool: 'none',
  entry: path.resolve(SRC_DIR, 'index.js'),
  output: {
    path: BUILD_DIR,
    filename: 'bundle.js'
  },
  plugins: [
    new CopyWebpackPlugin([
      {
        from: PUBLIC_DIR
      },
    ])
  ],
  module : {
    rules: [
      {
        test: /\.css$/,
        use: 'style-loader'
      },
      {
        test: /\.css$/,
        use: 'css-loader'
      },
      {
        test: /\.jsx?/,
        include: APP_DIR,
        use: 'babel-loader'
      },
      {
        // opal-webpack-bundler will compile and include ruby files in the pack
        test: /\.rb$/,
        use: [
          {
            loader: 'opal-webpack-bundler',
            options: {
              useBundler: true,
              paths: [path.resolve(__dirname)]
            }
          }
        ]
      }
    ]
  },
  devServer: {}
};
