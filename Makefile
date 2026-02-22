# systemd-boot-snapper-tools Makefile
PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin
PLUGINDIR = /usr/lib/snapper/plugins
SRC = src

SCRIPTS = snapper-boot-sync snapper-prune-broken snapper-rollback

.PHONY: install uninstall

install:
	# Create system directories
	install -d $(DESTDIR)$(BINDIR)
	install -d $(DESTDIR)$(PLUGINDIR)

	# Install binaries to /usr/bin
	for script in $(SCRIPTS); do \
		install -m 755 $(SRC)/$$script $(DESTDIR)$(BINDIR)/$$script; \
	done

	# Create the symlink for the snapper plugin
	# This ensures snapper-boot-sync runs on every snapshot event
	ln -sf $(BINDIR)/snapper-boot-sync $(DESTDIR)$(PLUGINDIR)/99-snapper-boot-sync

uninstall:
	for script in $(SCRIPTS); do \
		rm -f $(DESTDIR)$(BINDIR)/$$script; \
	done
	rm -f $(DESTDIR)$(PLUGINDIR)/99-snapper-boot-sync
