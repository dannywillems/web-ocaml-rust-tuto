const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const WasmPackPlugin = require("@wasm-tool/wasm-pack-plugin");
const webpack = require('webpack');

module.exports = {
    entry: './bootstrap.js',
    // Required!!!! See https://github.com/webpack/webpack/issues/6615#issuecomment-668177931
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: 'bundle.js'
    },
    plugins: [
        new HtmlWebpackPlugin(),
        new WasmPackPlugin({
            crateDirectory: path.resolve(__dirname, "rust"),
            outDir: path.resolve(__dirname, "ocaml/_build/default/src"),
        }),
    ],
    node: {
        fs: "empty",
    },
    mode: "production"
};
