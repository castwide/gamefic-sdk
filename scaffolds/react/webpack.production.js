const merge = require('webpack-merge');
const common = require('./webpack.common.js');
const path = require('path');

module.exports = merge(common, {
    output: {
        path: path.resolve(__dirname, "builds", "web")
    },
    resolve: {
        alias: {
            driver: path.join(__dirname, 'web', 'src', 'driver', 'production')
        }
    },
    module: {
        rules: [
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
        ]
    }
});
