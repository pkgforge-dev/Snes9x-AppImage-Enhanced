#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q sdlpop | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/opt/sdlpop/data/icon.png
export DESKTOP=/usr/share/applications/sdlpop.desktop
export DEPLOY_OPENGL=1

# Deploy dependencies
mv -r /opt/sdlpop ./AppDir/shared/
quick-sharun /usr/shared/sdlpop/prince
echo 'SHARUN_WORKING_DIR=${SHARUN_DIR}/shared/sdlpop' >> ./AppDir/.env

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage
