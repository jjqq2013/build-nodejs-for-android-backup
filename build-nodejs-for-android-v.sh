#!/bin/bash
function _msg { echo "$@" >&2; }

[[ $# == 0 ]] && { _msg "expect git tag as argument, for example: v6.6.0"; exit 1; }

cd ~/build-nodejs-for-android && git pull || exit 1
cd ~/android-gcc-toolchain && git pull || exit 1;

cd ~/node || exit 1
git clean -fdx; git reset --hard; git fetch;

TAG=$1
[[ $1 == v* ]] && TAG=${1#v} #remove first char v

git checkout "v$TAG" || exit 1
_msg ""
_msg "------------------------------------------------------------------------"
_msg current version of source of NodeJS: `git log -1 --oneline`
_msg "------------------------------------------------------------------------"

build-nodejs-for-android . --arch arm    -o ../nodejs-$TAG-android-arm         --pre-clean --post-clean         2>&1 | tee ../logs/nodejs-$TAG-android-arm
build-nodejs-for-android . --arch arm    -o ../nodejs-$TAG-android-arm-full    --pre-clean --post-clean --full  2>&1 | tee ../logs/nodejs-$TAG-android-arm-full
build-nodejs-for-android . --arch arm64  -o ../nodejs-$TAG-android-arm64       --pre-clean --post-clean         2>&1 | tee ../logs/nodejs-$TAG-android-arm64
build-nodejs-for-android . --arch arm64  -o ../nodejs-$TAG-android-arm64-full  --pre-clean --post-clean --full  2>&1 | tee ../logs/nodejs-$TAG-android-arm64-full
build-nodejs-for-android . --arch x86    -o ../nodejs-$TAG-android-x86         --pre-clean --post-clean         2>&1 | tee ../logs/nodejs-$TAG-android-x86
build-nodejs-for-android . --arch x86    -o ../nodejs-$TAG-android-x86-full    --pre-clean --post-clean --full  2>&1 | tee ../logs/nodejs-$TAG-android-x86-full
build-nodejs-for-android . --arch x64    -o ../nodejs-$TAG-android-x64         --pre-clean --post-clean         2>&1 | tee ../logs/nodejs-$TAG-android-x64
build-nodejs-for-android . --arch x64    -o ../nodejs-$TAG-android-x64-full    --pre-clean --post-clean --full  2>&1 | tee ../logs/nodejs-$TAG-android-x64-full
build-nodejs-for-android . --arch mipsel -o ../nodejs-$TAG-android-mipsel      --pre-clean --post-clean         2>&1 | tee ../logs/nodejs-$TAG-android-mipsel
build-nodejs-for-android . --arch mipsel -o ../nodejs-$TAG-android-mipsel-full --pre-clean --post-clean --full  2>&1 | tee ../logs/nodejs-$TAG-android-mipsel-full

echo done, please check ~/logs/ to confirm result.
