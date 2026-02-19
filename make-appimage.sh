#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/256x256/apps/snes9x.png
export DESKTOP=/usr/share/applications/snes9x-gtk.desktop
export STARTUPWMCLASS=snes9x-gtk
export DEPLOY_OPENGL=1
export DEPLOY_VULKAN=1
export DEPLOY_PIPEWIRE=1

# Deploy dependencies
quick-sharun /usr/bin/snes9x-gtk

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage
