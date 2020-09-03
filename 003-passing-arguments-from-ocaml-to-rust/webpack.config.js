const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const webpack = require('webpack');

module.exports = {
    // Required!!!! See https://github.com/webpack/webpack/issues/6615#issuecomment-668177931
    entry: './bootstrap.js',
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: 'bundle.js'
    },
    plugins: [
        new HtmlWebpackPlugin(),
    ],
    node: {
        fs: "empty",
    },
    mode: "development"
};