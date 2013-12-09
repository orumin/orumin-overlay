# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils multilib rpm

WRAPPER_VER="2.0.1-1"
LPR_VER="2.0.1-1"

DESCRIPTION="CUPS filters and drivers for Brother HL-5270DN"
HOMEPAGE="http://welcome.solution.brother.com/bsc/public_s/id/linux/en/download_prn.html"
SRC_URI="http://www.brother.com/pub/bsc/linux/dlf/brhl5270dnlpr-${LPR_VER}.i386.rpm
         http://www.brother.com/pub/bsc/linux/dlf/cupswrapperHL5270DN-${WRAPPER_VER}.i386.rpm
         http://www.brother.com/pub/bsc/linux/dlf/BR5270_2_GPL.ppd.gz"
LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="${DEPEND}"
RDEPEND="amd64? ( app-emulation/emul-linux-x86-baselibs )
         app-text/ghostscript-gpl
		 net-print/cups"

S="${WORKDIR}"
RESTRICT="strip"

src_prepare() {
	default
	epatch "${FILESDIR}/cupswrapper.patch"
}

src_install() {
	mkdir -p usr/share || die
	mv "${S}/usr/local/Brother" "${S}/usr/share/brother" || die

	sed -i "s;/usr/local/Brother;/usr/share/brother;g" $(grep -rl "/usr/local/Brother" .) || die

	mkdir -p "${S}/usr/share/brother/inf" || die
	echo "HL5270DN" > "${S}/usr/share/brother/inf/brPrintList" || die

	cd "${S}" || die
	./usr/share/brother/cupswrapper/cupswrapperHL5270DN-2.0.1 || die
	insinto /usr/share/cups/model
	newins "${WORKDIR}/BR5270_2_GPL.ppd" HL5270DN.ppd
	exeinto /usr/libexec/cups/filter
	doexe brlpdwrapperHL5270DN || die

	dodir /usr/share
	cd "${S}/usr/share" || die
	insinto /usr/share
	cp -rp brother "${D}/usr/share" || die
	fperms 0755 /usr/share/brother/inf/brHL5270DNrc

	dodir /usr/$(get_libdir)
	exeinto /usr/$(get_libdir)
	doexe "${S}"/usr/lib/*

	dodir /usr/bin
	exeinto /usr/bin
	doexe "${S}"/usr/bin/*
}
