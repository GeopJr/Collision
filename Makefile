.PHONY: all install uninstall test build mo desktop
PREFIX ?= /usr
PO_LOCATION ?= po
LOCALE_LOCATION ?= /share/locale

all: gresource desktop build

build:
	HASHBROWN_LOCALE_LOCATION="$(PREFIX)$(LOCALE_LOCATION)" $(CRYSTAL_LOCATION)shards build -Dpreview_mt --release --no-debug

test:
	$(CRYSTAL_LOCATION)crystal spec -Dpreview_mt --order random

gresource:
	glib-compile-resources --sourcedir data --target data/dev.geopjr.Hashbrown.gresource data/dev.geopjr.Hashbrown.gresource.xml

mo:
	mkdir -p $(PO_LOCATION)/mo
	for lang in `cat "$(PO_LOCATION)/LINGUAS"`; do \
		if [[ "$$lang" == 'en' || "$$lang" == '' ]]; then continue; fi; \
		mkdir -p "$(PREFIX)$(LOCALE_LOCATION)/$$lang/LC_MESSAGES"; \
		msgfmt "$(PO_LOCATION)/$$lang.po" -o "$(PO_LOCATION)/mo/$$lang.mo"; \
		install -D -m 0644 "$(PO_LOCATION)/mo/$$lang.mo" "$(PREFIX)$(LOCALE_LOCATION)/$$lang/LC_MESSAGES/dev.geopjr.Hashbrown.mo"; \
	done

metainfo:
	msgfmt --xml --template data/dev.geopjr.Hashbrown.metainfo.xml.in -d "$(PO_LOCATION)" -o data/dev.geopjr.Hashbrown.metainfo.xml

desktop:
	msgfmt --desktop --template data/dev.geopjr.Hashbrown.desktop.in -d "$(PO_LOCATION)" -o data/dev.geopjr.Hashbrown.desktop

install: mo
	install -D -m 0755 bin/hashbrown $(PREFIX)/bin/hashbrown
	install -D -m 0644 data/dev.geopjr.Hashbrown.desktop $(PREFIX)/share/applications/dev.geopjr.Hashbrown.desktop
	install -D -m 0644 data/icons/dev.geopjr.Hashbrown.svg $(PREFIX)/share/icons/hicolor/scalable/apps/dev.geopjr.Hashbrown.svg
	install -D -m 0644 data/icons/dev.geopjr.Hashbrown-symbolic.svg $(PREFIX)/share/icons/hicolor/symbolic/apps/dev.geopjr.Hashbrown-symbolic.svg
	gtk-update-icon-cache /usr/share/icons/hicolor

uninstall:
	rm -f $(PREFIX)/bin/hashbrown
	rm -f $(PREFIX)/share/applications/dev.geopjr.Hashbrown.desktop
	rm -f $(PREFIX)/share/icons/hicolor/scalable/apps/dev.geopjr.Hashbrown.svg
	rm -f $(PREFIX)/share/icons/hicolor/symbolic/apps/dev.geopjr.Hashbrown-symbolic.svg
	rm -rf $(PREFIX)$(LOCALE_LOCATION)/*/*/dev.geopjr.Hashbrown.mo
	gtk-update-icon-cache /usr/share/icons/hicolor
