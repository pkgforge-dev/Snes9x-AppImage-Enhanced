#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cairo               \
    cmake               \
    gdk-pixbuf2         \
    gtk3                \
    gtkmm3              \
    hicolor-icon-theme  \
    intltool            \
    libdecor            \
    libepoxy            \
    libxv               \
    meson               \
    minizip             \
    nasm                \
    pipewire-audio      \
    pipewire-jack       \
    portaudio           \
    sdl2

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package

# If the application needs to be manually built that has to be done down here
if [ "${DEVEL_RELEASE-}" = 1 ]; then
    echo "Making nightly build of Snes9x-GTK..."
    echo "---------------------------------------------------------------"
    REPO="https://github.com/snes9xgit/snes9x"
    VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
    git clone --recursive --depth 1 "$REPO" ./snes9x
    echo "$VERSION" > ~/version

    cd ./snes9x/unix
    ./configure \
        --prefix='/usr' \
        --enable-netplay \
        --with-system-zip
    make -j$(nproc)
    cd ../gtk
    mkdir -p build && cd build
    cmake .. \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_C_FLAGS="-Wno-error=format-security" \
        -DCMAKE_CXX_FLAGS="-Wno-error=format-security"
    make -j$(nproc)
    make install
else
    pacman -S --noconfirm snes9x-gtk snes9x
    pacman -Q snes9x-gtk | awk '{print $2; exit}' > ~/version
fi
