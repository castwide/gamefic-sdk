const path = require('path');
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = (env) => {
  var config = {
    entry: path.resolve(__dirname, 'web', 'src', 'index.js'),
    output: {
      filename: 'bundle.js',
      path: path.resolve(__dirname, "builds", "web", env)
    },
    resolve: {
      alias: {
        driver: path.join(__dirname, 'web', 'src', 'driver', env)
      }
    },
    plugins: [
        new CopyWebpackPlugin([
            {
                from: path.resolve(__dirname, 'web', 'public')
            },
        ])
    ],
    module: {
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
                include: path.resolve(__dirname, 'web'),
                use: 'babel-loader'
            }
        ]
    }
  }

  if (env == 'production') {
    config.module.rules.push(
      {
        // opal-webpack-bundler will compile and include ruby files in the pack
        test: /\.rb$/,
        use: [
          {
            loader: 'opal-webpack-bundler',
            options: {
              useBundler: true,
              paths: [path.resolve(__dirname)],
              sourceMap: false,
              root: path.resolve(__dirname)
            }
          }
        ]
      }
    );
  }

  return config;
};
