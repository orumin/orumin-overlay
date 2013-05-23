
EAPI=4
inherit xorg-2

DESCRIPTION="Generic Linux input driver with at-home-modifier"
SRC_URI="http://gitorious.org/at-home-modifier/download/blobs/raw/master/source/ahm-2.7.3.tar.gz"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.10[udev]
	sys-libs/mtdev"
DEPEND="${RDEPEND}
	>=x11-proto/inputproto-2.1.99.3
	>=sys-kernel/linux-headers-2.6"

src_unpack() {
	unpack ${A}
	mv at-home-modifier-at-home-modifier ${P}
}
src_configure() {
	cp -r ../${P} ../${P}_build
	cd ../${P}_build
	./autogen.sh --prefix=/usr
}
