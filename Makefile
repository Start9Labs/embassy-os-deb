VERSION = 0.3.x
TAG = v$(VERSION)
OS_ARCH := $(shell if [ -n "${OS_ARCH}" ]; then echo "${OS_ARCH}"; else uname -m; fi)
ARCH := $(shell if [ "$(OS_ARCH)" = "x86_64" ] || [ "$(OS_ARCH)" = "x86_64-nonfree" ]; then echo amd64; elif [ "$(OS_ARCH)" = "aarch64" ] || [ "$(OS_ARCH)" = "aarch64-nonfree" ] || [ "$(OS_ARCH)" = "raspberrypi" ]; then echo arm64; else echo "$(OS_ARCH)"; fi)


all: embassyos_$(VERSION)-1_$(ARCH).deb

clean:
	rm -rf embassyos-*
	rm -rf embassyos_*

embassyos-$(VERSION): $(shell find debian/)
	rm -rf embassyos-$(VERSION)
	git clone --depth=1 --recurse-submodules https://github.com/Start9Labs/embassy-os.git --branch=$(TAG) embassyos-$(VERSION)
	cp -r debian embassyos-$(VERSION)/
	VERSION=$(VERSION) ./control.sh
	cp embassyos-$(VERSION)/backend/embassyd.service embassyos-$(VERSION)/debian/embassyos.embassyd.service
	cp embassyos-$(VERSION)/backend/embassy-init.service embassyos-$(VERSION)/debian/embassyos.embassy-init.service

embassyos-$(VERSION).tar.gz: embassyos-$(VERSION)
	cd embassyos-$(VERSION) && make clean
	rm -f embassyos-$(VERSION).tar.gz
	tar --exclude-vcs -czf embassyos-$(VERSION).tar.gz embassyos-$(VERSION)

embassyos_$(VERSION)-1_$(ARCH).deb: embassyos-$(VERSION).tar.gz embassyos-$(VERSION)
	cd embassyos-$(VERSION) && debmake && CONFIG_SITE=/etc/dpkg-cross/cross-config.$(ARCH) DEB_BUILD_OPTIONS="parallel=1 nocheck" debuild --no-lintian -eOS_ARCH -eENVIRONMENT -ePATH -eUSER -Zgzip -I -a$(ARCH) -Pcross,nocheck
