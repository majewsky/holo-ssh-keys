default: prepare-build build/man/holo-ssh-keys.8

prepare-build:
	@mkdir -p build/man

# manpages are generated using pod2man (which comes with Perl and therefore
# should be readily available on almost every Unix system)
build/man/%: doc/%.pod
	pod2man --name="$(shell echo $* | cut -d. -f1)" --section=$(shell echo $* | cut -d. -f2) --center="Configuration Management" \
		--release="holo-ssh-keys $(shell git describe --tags)" \
		$< $@

install: default
	install -D -m 0644 build/man/holo-ssh-keys.8 "$(DESTDIR)/usr/share/man/man8/holo-ssh-keys.8"

.PHONY: prepare-build install