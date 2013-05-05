# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_5,2_6,2_7,3_1,3_2,3_3} )

inherit eutils multilib python-r1 toolchain-funcs versionator

MY_PV=$(get_version_component_range 1-2)

DESCRIPTION="GObject-based wrapper around the Exiv2 library."
HOMEPAGE="http://trac.yorba.org/wiki/gexiv2/"
SRC_URI="http://www.yorba.org/download/${PN}/${MY_PV}/lib${PN}_${PV}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="introspection static-libs python"

RDEPEND="
	dev-libs/glib:2
	>=media-gfx/exiv2-0.21
	introspection? ( dev-libs/gobject-introspection )
	python? (
		${PYTHON_DEPS}
		>=dev-python/pygobject-3.2.2[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/lib${P}

src_prepare() {
	epatch "${FILESDIR}/${PN}"-types.patch
	epatch "${FILESDIR}/${PN}"-langalt.patch
	tc-export CXX
	sed -e 's:CFLAGS:CXXFLAGS:g' -i Makefile || die
}

src_configure() {
	econf $(use_enable introspection)
}

src_install() {
	emake DESTDIR="${D}" LIB="$(get_libdir)" install
	dodoc AUTHORS NEWS README THANKS

	python_moduleinto gi/overrides/
	python_foreach_impl python_domodule GExiv2.py

	use static-libs || find "${D}" \( -name '*.a' -or -name '*.la' \) -delete
}