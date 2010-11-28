# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils qt4 git

EGIT_BRANCH="master"
EGIT_REPO_URI="git://gitorious.org/merkaartor/main.git"

DESCRIPTION="A Qt4 based map editor for the openstreetmap.org project"
HOMEPAGE="http://merkaartor.be/"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="nls webkit exif proj gdal gps"
DEPEND="x11-libs/qt-gui:4
	dev-libs/boost
	x11-libs/qt-svg:4
	webkit? ( >=x11-libs/qt-webkit-4.3.3 )
	exif? ( media-gfx/exiv2 )
	proj? ( sci-libs/proj )
	gdal? ( sci-libs/gdal )
	gps?  ( sci-geosciences/gpsd )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${FILESDIR}/timeout.diff"
}

src_compile() {
	sed -i -e "/QTcpServer/a #include <QTcpSocket>" src/MainWindow.cpp

	local myconf
	use webkit || myconf="${myconf} NOUSEWEBKIT=1"
	use exif && myconf="${myconf} GEOIMAGE=1" || myconf="${myconf} GEOIMAGE=0"
	use proj && myconf="${myconf} PROJ=1" || myconf="${myconf} PROJ=0"
	use gdal && myconf="${myconf} GDAL=1" || myconf="${myconf} GDAL=0"
	use gps && myconf="${myconf} GPSDLIB=1" || myconf="${myconf} GPSDLIB=0"

	if use nls; then
		lrelease src/src.pro || die "lrelease failed"
	fi

	eqmake4 Merkaartor.pro LIBDIR=$(get_libdir) PREFIX=/usr ${myconf} || die "eqmake4 failed"
	emake || die "make failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "install failed"
	dodoc AUTHORS CHANGELOG HACKING || die "dodoc failed"

	newicon Icons/Merkaartor_100x100.png "${PN}".png || die "newicon failed"
	make_desktop_entry "${PN}" "Merkaartor" "${PN}" "Science;Geoscience"
}
