# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for net-analyzer/smt"

ACCT_USER_ID=104
ACCT_USER_GROUPS=( "smt" )
ACCT_USER_HOME="/var/lib/smt"

acct-user_add_deps
