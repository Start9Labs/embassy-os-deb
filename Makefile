VERSION = 0.3.2
TAG = v$(VERSION)

all: embassyos_$(VERSION)-1_amd64.deb

clean:
	rm -rf embassyos-*
	rm -rf embassyos_*

embassyos-$(VERSION): $(shell find debian/)
	rm -rf embassyos-$(VERSION)
	git clone --depth=1 --recurse-submodules https://github.com/Start9Labs/embassy-os.git --branch=$(TAG) embassyos-$(VERSION)
	cp -r debian embassyos-$(VERSION)/

embassyos-$(VERSION).tar.gz: embassyos-$(VERSION)
	rm -f embassyos-$(VERSION).tar.gz
	tar --exclude-vcs -czf embassyos-$(VERSION).tar.gz embassyos-$(VERSION)

embassyos_$(VERSION)-1_amd64.deb: embassyos-$(VERSION).tar.gz embassyos-$(VERSION)
	cd embassyos-$(VERSION) && debmake && debuild -ePATH -eUSER -Zgzip -I