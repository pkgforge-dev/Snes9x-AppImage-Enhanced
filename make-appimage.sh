#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q snes9x-gtk-git | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/256x256/apps/snes9x.png
export DESKTOP=/usr/share/applications/snes9x-gtk.desktop
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun /usr/bin/snes9x-gtk

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage
