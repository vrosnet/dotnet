# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/xsp/xsp-2.0.ebuild,v 1.3 2008/11/27 18:46:27 ssuominen Exp $

EAPI=2

inherit go-mono mono

DESCRIPTION="XSP is a small web server that can host ASP.NET pages"
HOMEPAGE="http://www.go-mono.com/"

LICENSE="|| ( MIT X11 )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE=""

RDEPEND="dev-db/sqlite:3"
DEPEND="${RDEPEND}"

MAKEOPTS="${MAKEOPTS} -j1"

pkg_preinst() {
	enewgroup aspnet
	# Give aspnet home dir of /tmp since it must create ~/.wapi
	enewuser aspnet -1 -1 /tmp aspnet
}

src_install() {
	mv_command="cp -ar"
	go-mono_src_install

	newinitd "${FILESDIR}"/2.0/xsp.initd xsp || die
	newinitd "${FILESDIR}"/2.0/mod-mono-server.initd mod-mono-server || die
	newconfd "${FILESDIR}"/2.0/xsp.confd xsp || die
	newconfd "${FILESDIR}"/2.0/mod-mono-server.confd mod-mono-server || die

	keepdir /var/run/aspnet
}

pkg_postinst() {
	chown aspnet:aspnet /var/run/aspnet
}
