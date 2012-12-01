# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

PYTHON_COMPAT=( python2_6 python2_7 python3_1 python3_2 python3_3 )

inherit distutils-r1

MY_P=${P/_alph/}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Arbitrary precision correctly-rounded floating point arithmetic, via MPFR."
HOMEPAGE="https://bitbucket.org/dickinsm/bigfloat/src"
SRC_URI="http://pypi.python.org/packages/source/b/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/mpfr
        dev-libs/gmp"
RDEPEND="$DEPEND"

DOCS=( README CHANGELOG )

