# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kactivities"
inherit kde4-base

DESCRIPTION="KDE Activity Manager Daemon"
KEYWORDS="amd64 ~arm x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	!<kde-frameworks/kactivities-4.13.3-r1
	!kde-frameworks/kactivities:5
"

S=${WORKDIR}/${KMNAME}-${PV}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DWITH_NepomukCore=OFF
	)
	kde4-base_src_configure
}

src_install() {
	dobin "${BUILD_DIR}/src/service/${PN}"
}
