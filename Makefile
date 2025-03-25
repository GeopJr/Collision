.PHONY: all install uninstall test check build mo desktop gresource bindings install_nautilus_extension
PREFIX ?= /usr
PO_LOCATION ?= po
LOCALE_LOCATION ?= /share/locale

all: desktop bindings build

bindings: 
	./bin/gi-crystal || $(CRYSTAL_LOCATION)shards install && ./bin/gi-crystal

build:
	COLLISION_LOCALE_LOCATION="$(PREFIX)$(LOCALE_LOCATION)" $(CRYSTAL_LOCATION)shards build -Dpreview_mt --release --no-debug

check test:
	$(CRYSTAL_LOCATION)crystal spec -Dpreview_mt --order random

run:
	COLLISION_LOCALE_LOCATION="$(PREFIX)$(LOCALE_LOCATION)" $(CRYSTAL_LOCATION)shards run -Dpreview_mt

gresource:
	glib-compile-resources --sourcedir data --target data/dev.geopjr.Collision.gresource data/dev.geopjr.Collision.gresource.xml

mo:
	mkdir -p $(PO_LOCATION)/mo
	for lang in `cat "$(PO_LOCATION)/LINGUAS"`; do \
		if [[ "$$lang" == 'en' || "$$lang" == '' ]]; then continue; fi; \
		mkdir -p "$(PREFIX)$(LOCALE_LOCATION)/$$lang/LC_MESSAGES"; \
		msgfmt "$(PO_LOCATION)/$$lang.po" -o "$(PO_LOCATION)/mo/$$lang.mo"; \
		install -D -m 0644 "$(PO_LOCATION)/mo/$$lang.mo" "$(PREFIX)$(LOCALE_LOCATION)/$$lang/LC_MESSAGES/dev.geopjr.Collision.mo"; \
	done

metainfo:
	msgfmt --xml --template data/dev.geopjr.Collision.metainfo.xml.in -d "$(PO_LOCATION)" -o data/dev.geopjr.Collision.metainfo.xml

desktop:
	msgfmt --desktop --template data/dev.geopjr.Collision.desktop.in -d "$(PO_LOCATION)" -o data/dev.geopjr.Collision.desktop

install_nautilus_extension:
	mkdir -p  ~/.local/share/nautilus-python/extensions/
	cp nautilus-extension/collision-extension.py ~/.local/share/nautilus-python/extensions/
	nautilus -q || true

install: mo
	install -D -m 0755 bin/collision $(PREFIX)/bin/collision
	install -D -m 0644 data/dev.geopjr.Collision.gschema.xml $(PREFIX)/share/glib-2.0/schemas/dev.geopjr.Collision.gschema.xml
	install -D -m 0644 data/dev.geopjr.Collision.desktop $(PREFIX)/share/applications/dev.geopjr.Collision.desktop
	install -D -m 0644 data/icons/dev.geopjr.Collision.svg $(PREFIX)/share/icons/hicolor/scalable/apps/dev.geopjr.Collision.svg
	install -D -m 0644 data/icons/dev.geopjr.Collision-symbolic.svg $(PREFIX)/share/icons/hicolor/symbolic/apps/dev.geopjr.Collision-symbolic.svg
	gtk-update-icon-cache $(PREFIX)/share/icons/hicolor
	glib-compile-schemas $(PREFIX)/share/glib-2.0/schemas/

uninstall:
	rm -f $(PREFIX)/bin/collision
	rm -f $(PREFIX)/share/glib-2.0/schemas/dev.geopjr.Collision.gschema.xml
	rm -f $(PREFIX)/share/applications/dev.geopjr.Collision.desktop
	rm -f $(PREFIX)/share/icons/hicolor/scalable/apps/dev.geopjr.Collision.svg
	rm -f $(PREFIX)/share/icons/hicolor/symbolic/apps/dev.geopjr.Collision-symbolic.svg
	rm -rf $(PREFIX)$(LOCALE_LOCATION)/*/*/dev.geopjr.Collision.mo
	gtk-update-icon-cache $(PREFIX)/share/icons/hicolor

validate-appstream:
	appstreamcli validate ./data/dev.geopjr.Collision.metainfo.xml.in
