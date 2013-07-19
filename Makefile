JALAK_FILES = main.vala page.vala app.vala ./js/app.vala plugins.vala util.vala bridge.vala
JALAK_VALAFLAGS = --pkg gio-2.0 \
	  --pkg gmodule-2.0 \
	  --pkg libpeas-1.0 \
	  --pkg webkit-1.0 \
	  --pkg javascriptcore \
	  --target-glib=2.32 \
	  --thread \
	  --vapidir=./vapi

all: jalak foo

jalak:
	valac $(JALAK_VALAFLAGS) --header=jalak.h --vapi=jalak.vapi $(JALAK_FILES) -o jalak

foo: 
	valac $(JALAK_VALAFLAGS) --library=foo -X -shared -X -fPIC -X -I./ ./plugins/foo/foo.vala jalak.vapi -o ./plugins/foo/libfoo.so

volume: 
	valac $(JALAK_VALAFLAGS) --pkg libpulse --pkg posix --pkg libpulse-mainloop-glib  --library=volume -X -shared -X -fPIC -X -I./ ./plugins/volume/volume.vala ./plugins/volume/pulse_glue.vala jalak.vapi -o ./plugins/volume/libvolume.so
	


clean:
	rm -rf *.vapi *.h ./plugins/*/*.so jalak


