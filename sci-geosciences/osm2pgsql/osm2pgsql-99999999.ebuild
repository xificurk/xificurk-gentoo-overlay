# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils autotools subversion flag-o-matic

ESVN_REPO_URI="http://svn.openstreetmap.org/applications/utils/export/${PN}/"
ESVN_PROJECT="${PN}"

DESCRIPTION="Converts OSM data to SQL and insert into PostgreSQL db"
HOMEPAGE="http://wiki.openstreetmap.org/wiki/Osm2pgsql"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	app-arch/bzip2
	dev-db/postgis
	dev-libs/libxml2
	sci-libs/geos
	sci-libs/proj
	sys-libs/zlib
	dev-db/postgresql-base
"
RDEPEND="${DEPEND}"

pkg_setup() {
    append-ldflags $(no-as-needed)
}

src_prepare() {
	esvn_clean
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"

	dodoc README || die "dodoc failed"
}
