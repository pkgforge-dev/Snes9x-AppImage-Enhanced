# Maintainer: Joey Dumont <joey.dumont@gmail.com>
# Contributor: LIN Ruohshoei <lin dot ruohshoei+arch at gmail dot com>
# Contributor: Michael DeGuzis <mdeguzis@gmail.com>

pkgbase=snes9x-git
_pkgbase=snes9x
pkgname=(snes9x-gtk-git)
pkgver=1.63.r134.g83ebd9d9
pkgrel=1
pkgdesc="Portable Super Nintendo Entertainment System (TM) emulator - git version"
arch=('x86_64' 'aarch64')
url="http://www.snes9x.com/"
license=('custom')
makedepends=(alsa-lib cairo cmake gdk-pixbuf2 git glib2
    gtk3 gtkmm3 intltool libepoxy libpng libpulse libx11 libxext libxml2
    libxrandr libxv meson minizip nasm portaudio sdl2 zlib
    cmake
)
options=('!debug' 'strip')
source=(git+https://github.com/snes9xgit/snes9x.git)
sha256sums=('SKIP')

pkgver() {
    cd "${_pkgbase}"
    git describe --long --tags | sed -E 's/([^-]*-g)/r\1/;s/-/./g'

}
prepare() {
    cd ${_pkgbase}
    git submodule update --init --recursive

    cd unix
    autoreconf -fiv
}

build() {
    # Base Unix build
    export CFLAGS="$CFLAGS -Wno-error=format-security"
    export CXXFLAGS="$CXXFLAGS -Wno-error=format=security"

    pushd "${_pkgbase}/unix"
    ./configure \
        --prefix='/usr' \
        --enable-netplay
    make
    popd

    # Common CMake options for both GTK and Qt
    local common_cmake_args=(
        -DCMAKE_INSTALL_PREFIX=/usr
        -DCMAKE_C_FLAGS="-Wno-error=format-security"
        -DCMAKE_CXX_FLAGS="-Wno-error=format-security"
    )

    local gtk_args=("${common_cmake_args[@]}")
    cmake -B build -S snes9x/gtk "${gtk_args[@]}"
    cmake --build build
}

package_snes9x-gtk-git() {

    pkgdesc="Portable Emulator for the Super Nintendo Entertainment System - GTK version (git)"
    depends=(alsa-lib cairo gdk-pixbuf2 glib2 gtk3 hicolor-icon-theme libepoxy libpng libpulse libxext libxml2 libxrandr libxv minizip portaudio sdl2 gtkmm3)

    conflicts=('snes9x-gtk')
    provides=('snes9x-gtk')

    cd "${srcdir}"/build
    DESTDIR="${pkgdir}" cmake --install . --prefix=/usr

    cd "${srcdir}/${_pkgbase}"

    install -d "${pkgdir}/usr/share/doc/${pkgname}"
    install -Dm644 {unix/snes9x.conf.default,docs/{control-inputs,controls,snapshots}.txt} \
        "${pkgdir}/usr/share/doc/${pkgname}/"
    install -vDm644 LICENSE -t "${pkgdir}/usr/share/licenses/${pkgname}"
    rm "${pkgdir}/usr/share/snes9x/cheats.bml"
    #mv "${pkgdir}/usr/locale" "${pkgdir}/usr/share/locale"
}
