JALAK_FILES = main.vala page.vala app.vala ./js/app.vala plugins.vala util.vala bridge.vala
JALAK_VALAFLAGS = --pkg gio-2.0 \
	  --pkg gmodule-2.0 \
	  --pkg libpeas-1.0 \
	  --pkg webkitgtk-3.0 \
	  --pkg javascriptcore \
	  --target-glib=2.32 \
	  --thread \
	  --vapidir=./vapi

JALAK_XFLAGS = -X -I/usr/include/webkitgtk-3.0

all: jalak audio

jalak:
	valac $(JALAK_VALAFLAGS) --header=jalak.h --vapi=jalak.vapi $(JALAK_XFLAGS) $(JALAK_FILES) -o jalak

foo: 
	valac $(JALAK_VALAFLAGS) $(JALAK_XFLAGS) --library=foo -X -shared -X -fPIC -X -I./ ./plugins/foo/foo.vala jalak.vapi -o ./plugins/foo/libfoo.so

audio: 
	valac $(JALAK_VALAFLAGS) $(JALAK_XFLAGS) --pkg libpulse --pkg posix --pkg libpulse-mainloop-glib  --library=volume -X -shared -X -fPIC -X -I./ ./plugins/audio/audio.vala ./plugins/audio/audio_status.vala ./plugins/audio/audio_glue.vala jalak.vapi -o ./plugins/audio/libaudio.so

clean:
	rm -rf *.vapi *.h ./plugins/*/*.so jalak


