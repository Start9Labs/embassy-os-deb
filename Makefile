VERSION = 0.3.x
TAG = v$(VERSION)

all: embassyos_$(VERSION)-1_amd64.deb

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

embassyos_$(VERSION)-1_amd64.deb: embassyos-$(VERSION).tar.gz embassyos-$(VERSION)
	cd embassyos-$(VERSION) && debmake && DEB_BUILD_OPTIONS="parallel=1" debuild --no-lintian -ePATH -eUSER -Zgzip -I
