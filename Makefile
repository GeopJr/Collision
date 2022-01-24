.PHONY: all install uninstall
PREFIX ?= /usr

all:
	$(CRYSTAL_LOCATION)shards build -Dpreview_mt --release --no-debug

test:
	$(CRYSTAL_LOCATION)crystal spec

install:
	install -D -m 0755 bin/hashbrown $(PREFIX)/bin/hashbrown
	install -D -m 0644 extra/Hashbrown.desktop $(PREFIX)/share/applications/dev.geopjr.Hashbrown.desktop
	install -D -m 0644 extra/icons/logo.svg $(PREFIX)/share/icons/hicolor/scalable/apps/dev.geopjr.Hashbrown.svg
	install -D -m 0644 extra/icons/symbolic.svg $(PREFIX)/share/icons/hicolor/symbolic/apps/dev.geopjr.Hashbrown-symbolic.svg
	gtk-update-icon-cache /usr/share/icons/hicolor

uninstall:
	rm -f $(PREFIX)/bin/hashbrown
	rm -f $(PREFIX)/share/applications/dev.geopjr.Hashbrown.desktop
	rm -f $(PREFIX)/share/icons/hicolor/scalable/apps/dev.geopjr.Hashbrown.svg
	rm -f $(PREFIX)/share/icons/hicolor/symbolic/apps/dev.geopjr.Hashbrown-symbolic.svg
	gtk-update-icon-cache /usr/share/icons/hicolor
