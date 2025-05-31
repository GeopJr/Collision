.PHONY: all install uninstall test check build mo desktop gresource bindings install_nautilus_extension
PREFIX ?= /usr
PO_LOCATION ?= po
LOCALE_LOCATION ?= /share/locale
msys_sys ?= mingw64

all: desktop bindings build

bindings: 
	./bin/gi-crystal || $(CRYSTAL_LOCATION)shards install && ./bin/gi-crystal

build:
	COLLISION_LOCALE_LOCATION="$(PREFIX)$(LOCALE_LOCATION)" $(CRYSTAL_LOCATION)shards build -Dpreview_mt -Dexecution_context --release --no-debug

check test:
	$(CRYSTAL_LOCATION)crystal spec -Dpreview_mt -Dexecution_context --order random

run:
	COLLISION_LOCALE_LOCATION="$(PREFIX)$(LOCALE_LOCATION)" $(CRYSTAL_LOCATION)shards run -Dpreview_mt -Dexecution_context

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

windows:
	rm -rf "collision_windows"
	mkdir -p "collision_windows/bin"
	mkdir -p "collision_windows/share/applications"
	mkdir -p "collision_windows/share/glib-2.0/schemas"
	mkdir -p "collision_windows/share/icons"
	mkdir -p "collision_windows/share/locale"

	BLAKE3_CR_DO_NOT_BUILD=1 COLLISION_LOCALE_LOCATION=".$(LOCALE_LOCATION)" $(CRYSTAL_LOCATION)shards build -Dpreview_mt -Dexecution_context --release --no-debug
	mv ./bin/collision.exe ./collision_windows/bin/dev.geopjr.Collision.exe

	wget -nc https://github.com/electron/rcedit/releases/download/v1.1.1/rcedit-x64.exe
	rsvg-convert ./data/icons/dev.geopjr.Collision.svg -o ./data/icons/dev.geopjr.Collision.png -h 256 -w 256
	magick -density "256x256" -background transparent ./data/icons/dev.geopjr.Collision.png -define icon:auto-resize -colors 256 ./data/icons/dev.geopjr.Collision.ico
	./rcedit-x64.exe ./collision_windows/bin/dev.geopjr.Collision.exe --set-icon ./data/icons/dev.geopjr.Collision.ico

	ldd ./collision_windows/bin/dev.geopjr.Collision.exe | grep '\/$(msys_sys).*\.dll' -o | xargs -I{} cp "{}" ./collision_windows/bin
	cp -f /$(msys_sys)/bin/gdbus.exe ./collision_windows/bin && ldd ./collision_windows/bin/gdbus.exe | grep '\/$(msys_sys).*\.dll' -o | xargs -I{} cp "{}" ./collision_windows/bin
	cp -f /$(msys_sys)/bin/gspawn-win64-helper.exe ./collision_windows/bin && ldd ./collision_windows/bin/gspawn-win64-helper.exe | grep '\/$(msys_sys).*\.dll' -o | xargs -I{} cp "{}" ./collision_windows/bin
	cp -f /$(msys_sys)/bin/librsvg-2-2.dll /$(msys_sys)/bin/libgthread-2.0-0.dll /$(msys_sys)/bin/libgmp-10.dll ./collision_windows/bin
	cp -r /$(msys_sys)/lib/gio/ ./collision_windows/lib
	cp -r /$(msys_sys)/lib/gdk-pixbuf-2.0 ./collision_windows/lib/gdk-pixbuf-2.0

	ldd ./collision_windows/lib/gio/*/*.dll | grep '\/$(msys_sys).*\.dll' -o | xargs -I{} cp "{}" ./collision_windows/bin
	ldd ./collision_windows/bin/*.dll | grep '\/$(msys_sys).*\.dll' -o | xargs -I{} cp "{}" ./collision_windows/bin
	ldd ./collision_windows/lib/gdk-pixbuf-2.0/*/loaders/*.dll | grep '\/$(msys_sys).*\.dll' -o | xargs -I{} cp "{}" ./collision_windows/bin

	cp -r /$(msys_sys)/share/glib-2.0/schemas/*.xml ./collision_windows/share/glib-2.0/schemas/
	cp ./data/dev.geopjr.Collision.gschema.xml ./collision_windows/share/glib-2.0/schemas/
	glib-compile-schemas.exe ./collision_windows/share/glib-2.0/schemas/

	mkdir -p $(PO_LOCATION)/mo
	for lang in `cat "$(PO_LOCATION)/LINGUAS"`; do \
		if [[ "$$lang" == 'en' || "$$lang" == '' ]]; then continue; fi; \
		mkdir -p "./collision_windows$(LOCALE_LOCATION)/$$lang/LC_MESSAGES"; \
		msgfmt "$(PO_LOCATION)/$$lang.po" -o "$(PO_LOCATION)/mo/$$lang.mo"; \
		install -D -m 0644 "$(PO_LOCATION)/mo/$$lang.mo" "./collision_windows$(LOCALE_LOCATION)/$$lang/LC_MESSAGES/dev.geopjr.Collision.mo"; \
	done
	msgfmt --desktop --template data/dev.geopjr.Collision.desktop.in -d "$(PO_LOCATION)" -o ./collision_windows/share/applications/dev.geopjr.Collision.desktop

	cp -r /$(msys_sys)/share/icons/ ./collision_windows/share/

	rm -f ./collision_windows/share/glib-2.0/schemas/*.xml
	rm -rf ./collision_windows/share/icons/hicolor/scalable/actions/
	find ./collision_windows/share/icons/ -name *.*.*.svg -not -name *geopjr* -delete
	find ./collision_windows/lib/gdk-pixbuf-2.0/2.10.0/loaders -name *.a -not -name *geopjr* -delete
	find ./collision_windows/share/icons/ -name mimetypes -type d  -exec rm -r {} + -depth
	find ./collision_windows/share/icons/hicolor/ -path */apps/*.png -not -name *geopjr* -delete
	find ./collision_windows/ -type d -empty -delete
	gtk-update-icon-cache ./collision_windows/share/icons/Adwaita/
	gtk-update-icon-cache ./collision_windows/share/icons/hicolor/

	zip -r9q collision_windows.zip collision_windows/
