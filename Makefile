default: prepare-build build/holo-ssh-keys build/man/holo-ssh-keys.8

prepare-build:
	@mkdir -p build/man
build/holo-ssh-keys: src/main.go # src/*/*.go
	go build -o $@ $<

# manpages are generated using pod2man (which comes with Perl and therefore
# should be readily available on almost every Unix system)
build/man/%: doc/%.pod
	pod2man --name="$(shell echo $* | cut -d. -f1)" --section=$(shell echo $* | cut -d. -f2) --center="Configuration Management" \
		--release="holo-ssh-keys $(shell git describe --tags)" \
		$< $@

test: check # just a synonym
check: default
	@go test ./src/impl

install: default src/holorc.holoscript
	install -D -m 0755 build/holo-ssh-keys       "$(DESTDIR)/usr/lib/holo/holo-ssh-keys"
	install -D -m 0755 src/holorc.holoscript     "$(DESTDIR)/usr/share/holo/files/02-holo-ssh-keys/etc/holorc.holoscript"
	install -D -m 0644 build/man/holo-ssh-keys.8 "$(DESTDIR)/usr/share/man/man8/holo-ssh-keys.8"

.PHONY: prepare-build test check install
