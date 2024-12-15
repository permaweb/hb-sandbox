#!/bin/sh

docker run --rm -e DEBUG=1 -v ./ao-process/:/src --platform linux/amd64 hbwasm:latest ao-build-module

cp ./ao-process/process.wasm ./process.wasm
rm ./ao-process/process.wasm