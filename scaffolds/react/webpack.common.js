const path = require('path');
const CopyWebpackPlugin = require('copy-webpack-plugin');

var APP_DIR = path.resolve(__dirname, 'web');
var SRC_DIR = path.resolve(APP_DIR, 'src');
var PUB_DIR = path.resolve(APP_DIR, 'public');

module.exports = {
    entry: path.resolve(SRC_DIR, 'index.js'),
    output: {
        filename: 'bundle.js'
    },
    plugins: [
        new CopyWebpackPlugin([
            {
                from: PUB_DIR
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
                include: APP_DIR,
                use: 'babel-loader'
            }
        ]
    }
};
