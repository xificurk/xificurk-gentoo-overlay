# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit games

DESCRIPTION="Reimplementation of the fun puzzle game originally published by Ocean"
HOMEPAGE="http://pushover.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/sdl-mixer
	media-libs/sdl-ttf
	sys-libs/zlib
	dev-lang/lua"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS="AUTHORS ChangeLog"

src_prepare() {
	sed -i -e "s: install-dist_docDATA ::" Makefile.in || die "Patching Makefile.in failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog readme.txt || die "dodoc failed"
	prepgamesdirs
}
