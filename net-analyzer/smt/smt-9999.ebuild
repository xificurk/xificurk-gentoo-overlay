# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

EGIT_REPO_URI="https://github.com/xificurk/smt.git"
PYTHON_COMPAT=( python3_1 python3_2 python3_3 python3_4 python3_5 python3_6 python3_7 python3_8 python3_9 python3_10 )

inherit distutils-r1 git-r3

DESCRIPTION="Simple monitoring tool for various sensors."
HOMEPAGE="https://github.com/xificurk/smt"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	acct-group/smt
	acct-user/smt
"
RDEPEND="${DEPEND}
	net-analyzer/rrdtool
"

DOCS=( README.md CHANGES )


python_install() {
	distutils-r1_python_install

	# install scripts
	python_scriptinto /usr/sbin
	python_doscript bin/smtd
	fowners smt:smt "/usr/lib/python-exec/${EPYTHON}/smtd"
	fperms 750 "/usr/lib/python-exec/${EPYTHON}/smtd"
	python_doscript bin/smt-limits
	fowners smt:smt "/usr/lib/python-exec/${EPYTHON}/smt-limits"
	fperms 750 "/usr/lib/python-exec/${EPYTHON}/smt-limits"
}

src_install() {
	distutils-r1_src_install

	# install example plugins configuration
	keepdir /etc/smt/plugins
	insinto /etc/smt/plugins
	newins config/plugins.py __init__.py

	# install init script and its configuration
	newinitd gentoo/smt-init smt
	newconfd gentoo/smt-conf smt

	# install logrotate file
	insinto /etc/logrotate.d
	newins gentoo/smt-logrotate smt

	# create data dir
	local dirs
	dirs="/var/lib/smt/data /var/lib/smt/state"
	keepdir $dirs
	fowners smt:smt $dirs
	fperms 775 $dirs
}
