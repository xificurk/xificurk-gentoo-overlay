# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit kde4-meta-pkg

DESCRIPTION="KDE bindings - merge this to pull in all kdebindings-derived packages"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="java perl python ruby"

RDEPEND="
	$(add_kdeapps_dep smokegen)
	$(add_kdeapps_dep smokekde)
	$(add_kdeapps_dep smokeqt)
	java? ( $(add_kdeapps_dep krossjava) )
	perl? (
		$(add_kdeapps_dep perlkde)
		$(add_kdeapps_dep perlqt)
	)
	python? (
		$(add_kdeapps_dep krosspython)
		$(add_kdeapps_dep pykde4)
	)
"
