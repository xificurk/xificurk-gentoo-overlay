# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

EGIT_REPO_URI="https://github.com/vwal/nfs_automount.git"

inherit git-r3

DESCRIPTION="Keeps NFS mounts active. Also enables cross-mounts between servers."
HOMEPAGE="https://github.com/vwal/nfs_automount"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="app-shells/bash
	net-fs/nfs-utils
	net-nds/rpcbind
	sys-apps/util-linux
	sys-apps/grep
	virtual/awk"

DOCS=( README )


src_install() {
	into /usr
	dosbin nfs_automount

	insinto /etc
	doins etc/nfs_automount.conf

	# install init script
	newinitd "${FILESDIR}/nfs_automount.init" nfs_automount

	# install logrotate file
	insinto /etc/logrotate.d
	newins "${FILESDIR}/nfs_automount.logrotate" nfs_automount
}
