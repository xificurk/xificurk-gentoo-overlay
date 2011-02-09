# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=2
inherit cmake-utils git

EGIT_REPO_URI="https://github.com/AMDmi3/${PN}.git"
KEYWORDS="~amd64 ~x86"

DESCRIPTION="OpenGL viewer and tiler for openstreetmap"
HOMEPAGE="http://glosm.amdmi3.ru/"

LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/expat
	virtual/opengl
	media-libs/freeglut
	media-libs/libpng
	x11-libs/libX11
"
DEPEND=""

src_configure() {
	cmake-utils_src_configure
}
