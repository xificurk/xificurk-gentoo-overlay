# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit mono eutils

DESCRIPTION="Easy to use, linux based program for managing your geocaches"
HOMEPAGE="http://opencachemanage.sourceforge.net/"
SRC_URI="mirror://sourceforge/opencachemanage/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-dotnet/dbus-glib-sharp
	dev-dotnet/dbus-sharp
	dev-dotnet/gconf-sharp
	dev-dotnet/glib-sharp
	dev-dotnet/gtk-sharp
	dev-dotnet/webkit-sharp
	dev-lang/mono
	sci-geosciences/gpsbabel"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"


src_unpack() {
    unpack ${A}
    cd "${S}"

    epatch "${FILESDIR}"/${P}-destdir.patch
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
}