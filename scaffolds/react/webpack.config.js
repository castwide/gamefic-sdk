const path = require('path');
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = (_env, argv) => {
  var config = {
    entry: path.resolve(__dirname, 'web', 'src', 'index.js'),
    output: {
      filename: 'bundle.js',
      path: path.resolve(__dirname, "builds", "web", argv.mode)
    },
    resolve: {
      alias: {
        driver: path.join(__dirname, 'web', 'src', 'driver', argv.mode)
      }
    },
    plugins: [
      new CopyWebpackPlugin({
        patterns: [
          {
            from: path.resolve(__dirname, 'web', 'public')
          }
        ]
      })
    ],
    module: {
        rules: [
            {
                test: /\.css$/,
                use: ['style-loader', 'css-loader']
            },
            {
              test: /\.(png|jp(e*)g|svg)$/,  
              use: [{
                  loader: 'url-loader',
                  options: { 
                      limit: 8000, // Convert images < 8kb to base64 strings
                      name: 'images/[hash]-[name].[ext]'
                  } 
              }]
            },
            {
                test: /\.jsx?/,
                include: path.resolve(__dirname, 'web'),
                use: 'babel-loader'
            }
        ]
    }
  }

  if (argv.mode == 'production') {
    config.module.rules.push(
      {
        // opal-webpack-bundler will compile and include ruby files in the pack
        test: /\.rb$/,
        use: [
          {
            loader: 'opal-webpack-bundler',
            options: {
              useBundler: true,
              paths: [path.resolve(__dirname), path.resolve(__dirname, 'lib')],
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
