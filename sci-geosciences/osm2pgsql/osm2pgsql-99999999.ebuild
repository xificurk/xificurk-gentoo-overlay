# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools git-2

EGIT_REPO_URI="git://github.com/openstreetmap/${PN}.git"

DESCRIPTION="Converts OSM data to SQL and insert into PostgreSQL db"
HOMEPAGE="http://wiki.openstreetmap.org/wiki/Osm2pgsql"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="pbf"

DEPEND="
	app-arch/bzip2
	dev-db/postgis
	dev-libs/libxml2:2
	sci-libs/geos
	sci-libs/proj
	sys-libs/zlib
	dev-db/postgresql-base
	pbf? ( dev-libs/protobuf-c )"

RDEPEND="${DEPEND}"

DOCS=( README 900913.sql )
