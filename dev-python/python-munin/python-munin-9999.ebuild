# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

PYTHON_COMPAT="python2_5 python2_6 python2_7"
EGIT_REPO_URI="git://github.com/samuel/python-munin"

inherit git python-distutils-ng

DESCRIPTION="Helper classes for writing plugins for the server monitoring tool Munin."
HOMEPAGE="http://samuelks.com/python-munin/"

LICENSE="MIT"
SLOT="0"

KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=""
