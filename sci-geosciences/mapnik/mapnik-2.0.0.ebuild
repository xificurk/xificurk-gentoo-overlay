# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="python? 2"
inherit eutils scons-utils toolchain-funcs python versionator

DESCRIPTION="A Free Toolkit for developing mapping applications."
HOMEPAGE="http://www.mapnik.org/"
SRC_URI="mirror://berlios/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="cairo debug doc python curl +gdal oracle postgres sqlite"

RDEPEND=">=dev-libs/boost-1.45
	>=dev-libs/icu-4.2
	dev-libs/libxml2:2
	media-fonts/dejavu
	media-libs/freetype:2
	virtual/jpeg
	media-libs/libpng
	media-libs/tiff
	sci-libs/proj
	x11-libs/agg[truetype]
	cairo? (
		x11-libs/cairo
		dev-cpp/cairomm
		python? ( dev-python/pycairo )
	)
	python? ( dev-libs/boost[python] )
	curl? ( net-misc/curl )
	gdal? ( sci-libs/gdal )
	oracle? ( >=dev-db/oracle-instantclient-basic-10.2.0.1 )
	postgres? (
		>=dev-db/postgresql-base-8.3
		>=dev-db/postgis-1.5.2
	)
	sqlite? ( dev-db/sqlite:3 )"

DEPEND="${RDEPEND}
	doc? ( python? ( dev-python/epydoc ) )
	dev-util/scons"

src_prepare() {
	rm -rf agg || die
	epatch "${FILESDIR}/${P}-libagg.patch"
	epatch "${FILESDIR}/${P}-ldconfig.patch"
	epatch "${FILESDIR}/${P}-line-offset.patch"
}

src_configure() {
	EMAKEOPTS="SYSTEM_FONTS=/usr/share/fonts/dejavu"
	EMAKEOPTS="${EMAKEOPTS} PREFIX=/usr"
	EMAKEOPTS="${EMAKEOPTS} PROJ_INCLUDES=/usr/include"
	EMAKEOPTS="${EMAKEOPTS} PROJ_LIBS=/usr/$(get_libdir)"

	EMAKEOPTS="${EMAKEOPTS} INPUT_PLUGINS="
	use curl     && EMAKEOPTS="${EMAKEOPTS}osm,"
	use gdal     && EMAKEOPTS="${EMAKEOPTS}gdal,ogr,"
	use oracle   && EMAKEOPTS="${EMAKEOPTS}occi,"
	use postgres && EMAKEOPTS="${EMAKEOPTS}postgis,"
	use sqlite   && EMAKEOPTS="${EMAKEOPTS}sqlite,"
	EMAKEOPTS="${EMAKEOPTS}shape,raster"

	use cairo  || EMAKEOPTS="${EMAKEOPTS} CAIRO=false"
	use python || EMAKEOPTS="${EMAKEOPTS} BINDINGS=none"
	use debug  && EMAKEOPTS="${EMAKEOPTS} DEBUG=yes"

	use postgres && use sqlite && EMAKEOPTS="${EMAKEOPTS} PGSQL2SQLITE=yes"

	BOOST_PKG="$(best_version "dev-libs/boost")"
	BOOST_VER="$(get_version_component_range 1-2 "${BOOST_PKG/*boost-/}")"
	export BOOST_VERSION="$(replace_all_version_separators _ "${BOOST_VER}")"
	elog "${P} BOOST_VERSION is ${BOOST_VERSION}"
	export BOOST_INC="/usr/include/boost-${BOOST_VERSION}"
	elog "${P} BOOST_INC is ${BOOST_INC}"
	BOOST_LIBDIR_SCHEMA="$(get_libdir)/boost-${BOOST_VERSION}"
	export BOOST_LIB="/usr/${BOOST_LIBDIR_SCHEMA}"
	elog "${P} BOOST_LIB is ${BOOST_LIB}"

	# Passing things doesn't seem to hit all the right paths; another
	# poster-child for just a bit too much complexity for its own good.
	# See bug #301674 for more info.
	sed -i -e "s|searchDir, LIBDIR_SCHEMA|searchDir, \'${BOOST_LIBDIR_SCHEMA}\'|" \
		-i -e "s|include/boost*|include/boost-${BOOST_VERSION}|" \
		SConstruct || die "sed boost paths failed..."

	# this seems to be the only way to force user-flags, since nothing
	# gets through the scons configure except the nuclear sed option.
	sed -i -e "s:\-O%s:${CXXFLAGS}:" \
		-i -e "s:env\['OPTIMIZATION'\]\,::" \
		SConstruct || die "sed CXXFLAGS failed"
	sed -i -e "s:LINKFLAGS=linkflags:LINKFLAGS=linkflags + \" ${LDFLAGS}\":" \
		src/build.py || die "sed LDFLAGS failed"

	escons CC="$(tc-getCC)" CXX="$(tc-getCXX)" CUSTOM_LDFLAGS="${LDFLAGS}" \
		${EMAKEOPTS} configure || die "scons configure failed"
}

src_compile() {
	# note passing CXXFLAGS to scons does *not* work
	escons CC="$(tc-getCC)" CXX="$(tc-getCXX)" CUSTOM_LDFLAGS="${LDFLAGS}" \
		shared=1 || die "scons make failed"

	# this is known to depend on mod_python and should not have a
	# "die" after the epydoc script (see bug #370575)
	if use doc && use python; then
		export PYTHONPATH="${S}/bindings/python:$(python_get_sitedir)"
		cd docs/epydoc_config && ./build_epydoc.sh
		cd -
	fi
}

src_install() {
	escons DESTDIR="${D}" install || die "scons install failed"

	if use python ; then
		fperms 0644 "$(python_get_sitedir)"/mapnik2/paths.py
		dobin utils/stats/mapdef_stats.py
		insinto /usr/share/doc/${PF}/examples
		doins utils/ogcserver/*
	fi

	dodoc AUTHORS CHANGELOG README || die
	use doc && use python && { dohtml -r docs/api_docs/python/* || die "API doc install failed"; }
}
