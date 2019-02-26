NAME   = uae4all.dge
O      = o
RM     = rm -f

CHAINPREFIX := /opt/mipsel-linux-uclibc
CROSS_COMPILE := $(CHAINPREFIX)/usr/bin/mipsel-linux-

CC = $(CROSS_COMPILE)gcc
CXX = $(CROSS_COMPILE)g++
STRIP = $(CROSS_COMPILE)strip

SYSROOT     := $(shell $(CC) --print-sysroot)
SDL_CFLAGS  := $(shell $(SYSROOT)/usr/bin/sdl-config --cflags)
SDL_LIBS    := $(shell $(SYSROOT)/usr/bin/sdl-config --libs)

PROG		= $(NAME)
RELEASEDIR	= uae4all
DATADIR		= data
OPKDIR		= opk_data

all: $(PROG)

#FAME_CORE=1
LIB7Z=1

HOME_DIR=1

DEFAULT_CFLAGS = -I$(CHAINPREFIX)/usr/include/ $(SDL_CFLAGS) -D_GNU_SOURCE=1 -D_REENTRANT -DGCW0

LDFLAGS = -lSDL -lSDL_image -lz -lpthread -flto
# add -lSDL_mixer if -DMENU_MUSIC below
ifndef FAME_CORE
LDFLAGS += -lm
endif
#-s -static


MORE_CFLAGS = -Isrc/ -Isrc/include/ -Isrc/menu -Isrc/vkbd -fomit-frame-pointer  -Wno-unused -Wno-format -DUSE_SDL -DGCCCONSTFUNC="__attribute__((const))" -DUSE_UNDERSCORE -fno-exceptions -DUNALIGNED_PROFITABLE -DREGPARAM="__attribute__((regparm(3)))" -DOPTIMIZED_FLAGS -D__inline__=__inline__ -DSHM_SUPPORT_LINKS=0 -DOS_WITHOUT_MEMORY_MANAGEMENT -DVKBD_ALWAYS

MORE_CFLAGS += -O3 -flto -mno-shared -pipe -fno-exceptions -fno-rtti

MORE_CFLAGS+= -DROM_PATH_PREFIX=\"./\" -DDATA_PREFIX=\"./data/\" -DSAVE_PREFIX=\"./\"

MORE_CFLAGS+= -DDOUBLEBUFFER
MORE_CFLAGS+= -DNO_DEFAULT_THROTTLE

#MORE_CFLAGS+= -DSTATUS_ALWAYS
#MORE_CFLAGS+= -DUSE_MAYBE_BLIT
#MORE_CFLAGS+= -DUSE_BLITTER_DELAYED
#MORE_CFLAGS+= -DUSE_BLIT_FUNC
#MORE_CFLAGS+= -DUSE_LARGE_BLITFUNC
#MORE_CFLAGS+= -DUSE_VAR_BLITSIZE
#MORE_CFLAGS+= -DUSE_SHORT_BLITTABLE
MORE_CFLAGS+= -DUSE_BLIT_MASKTABLE
#MORE_CFLAGS+= -DUSE_RASTER_DRAW
#MORE_CFLAGS+= -DUSE_ALL_LINES
#MORE_CFLAGS+= -DUSE_LINESTATE
#MORE_CFLAGS+= -DUSE_DISK_UPDATE_PER_LINE
#MORE_CFLAGS+= -DMENU_MUSIC
#MORE_CFLAGS+= -DUSE_AUTOCONFIG
#MORE_CFLAGS+= -DUAE_CONSOLE

MORE_CFLAGS+= -DUSE_ZFILE

#MORE_CFLAGS+= -DUAE4ALL_NO_USE_RESTRICT

#MORE_CFLAGS+= -DNO_SOUND
MORE_CFLAGS+= -DNO_THREADS

#MORE_CFLAGS+= -DDEBUG_TIMESLICE

MORE_CFLAGS+= -DEMULATED_JOYSTICK
MORE_CFLAGS+= -DFAME_INTERRUPTS_PATCH
#MORE_CFLAGS+= -DFAME_INTERRUPTS_SECURE_PATCH
#MORE_CFLAGS+= -DSECURE_BLITTER

#MORE_CFLAGS+= -DUAE_MEMORY_ACCESS
#MORE_CFLAGS+= -DSAFE_MEMORY_ACCESS
#MORE_CFLAGS+= -DERROR_WHEN_MEMORY_OVERRUN

#MORE_CFLAGS+= -DDEBUG_UAE4ALL
#MORE_CFLAGS+= -DDEBUG_UAE4ALL_FFLUSH
#MORE_CFLAGS+= -DDEBUG_M68K
#MORE_CFLAGS+= -DDEBUG_INTERRUPTS
##MORE_CFLAGS+= -DDEBUG_CIA
#MORE_CFLAGS+= -DDEBUG_SOUND
#MORE_CFLAGS+= -DDEBUG_MEMORY
###MORE_CFLAGS+= -DDEBUG_MAPPINGS
##MORE_CFLAGS+= -DDEBUG_DISK
##MORE_CFLAGS+= -DDEBUG_CUSTOM
###MORE_CFLAGS+= -DDEBUG_EVENTS
###MORE_CFLAGS+= -DDEBUG_GFX -DDEBUG_BLITTER
#MORE_CFLAGS+= -DDEBUG_FRAMERATE
#MORE_CFLAGS+= -DAUTO_FRAMERATE=1400
#MORE_CFLAGS+= -DMAX_AUTO_FRAMERATE=4400
###MORE_CFLAGS+= -DAUTO_FRAMERATE_SOUND
##MORE_CFLAGS+= -DSTART_DEBUG=11554
##MORE_CFLAGS+= -DMAX_AUTOEVENTS=11560
#MORE_CFLAGS+= -DSTART_DEBUG=11554
#MORE_CFLAGS+= -DMAX_AUTOEVENTS=5000
#MORE_CFLAGS+= -DAUTO_RUN
#MORE_CFLAGS+= -DAUTOEVENTS
#MORE_CFLAGS+= -DPROFILER_UAE4ALL
#MORE_CFLAGS+= -DAUTO_PROFILER=4000
#MORE_CFLAGS+= -DMAX_AUTO_PROFILER=5000


#MORE_CFLAGS+= -DPROFILER_UAE4ALL

CFLAGS  = $(DEFAULT_CFLAGS) $(MORE_CFLAGS)

OBJS =	\
	src/savestate.o \
	src/audio.o \
	src/autoconf.o \
	src/blitfunc.o \
	src/blittable.o \
	src/blitter.o \
	src/cia.o \
	src/savedisk.o \
	src/compiler.o \
	src/custom.o \
	src/disk.o \
	src/drawing.o \
	src/ersatz.o \
	src/gfxutil.o \
	src/keybuf.o \
	src/main.o \
	src/md-support.o \
	src/memory.o \
	src/missing.o \
	src/gui.o \
	src/od-joy.o \
	src/sound.o \
	src/sdlgfx.o \
	src/writelog.o \
	src/zfile.o \
	src/menu/fade.o \
	src/menu/menu.o \
	src/menu/menu_save.o \
	src/menu/menu_load.o \
	src/menu/menu_df_selection.o \
	src/menu/menu_main.o \
	src/vkbd/vkbd.o \
	src/dingoo.o \

ifdef LIB7Z
CFLAGS+=-DUSE_LIB7Z
OBJS+= \
	src/lib7z/7zAlloc.o \
	src/lib7z/7zBuf2.o \
	src/lib7z/7zBuf.o \
	src/lib7z/7zCrc.o \
	src/lib7z/7zDecode.o \
	src/lib7z/7zExtract.o \
	src/lib7z/7zFile.o \
	src/lib7z/7zHeader.o \
	src/lib7z/7zIn.o \
	src/lib7z/7zItem.o \
	src/lib7z/7zStream.o \
	src/lib7z/Alloc.o \
	src/lib7z/Bcj2.o \
	src/lib7z/Bra86.o \
	src/lib7z/BraIA64.o \
	src/lib7z/Bra.o \
	src/lib7z/LzFind.o \
	src/lib7z/LzmaDec.o \
	src/lib7z/LzmaEnc.o \
	src/lib7z/lzma.o
endif

ifdef HOME_DIR
CFLAGS+=-DHOME_DIR
OBJS+= \
	src/homedir.o
endif

ifdef FAME_CORE
#CFLAGS+=-DUSE_FAME_CORE -DUSE_FAME_CORE_C -DFAME_INLINE_LOOP -DFAME_IRQ_CLOCKING -DFAME_CHECK_BRANCHES -DFAME_EMULATE_TRACE -DFAME_DIRECT_MAPPING -DFAME_BYPASS_TAS_WRITEBACK -DFAME_ACCURATE_TIMING -DFAME_GLOBAL_CONTEXT -DFAME_FETCHBITS=8 -DFAME_DATABITS=8 -DFAME_GOTOS -DFAME_EXTRA_INLINE=__inline__ -DINLINE=__inline__ -DFAME_NO_RESTORE_PC_MASKED_BITS
CFLAGS+=-DUSE_FAME_CORE -DUSE_FAME_CORE_C -DFAME_IRQ_CLOCKING -DFAME_CHECK_BRANCHES -DFAME_EMULATE_TRACE -DFAME_DIRECT_MAPPING -DFAME_BYPASS_TAS_WRITEBACK -DFAME_ACCURATE_TIMING -DFAME_GLOBAL_CONTEXT -DFAME_FETCHBITS=8 -DFAME_DATABITS=8 -DFAME_GOTOS -DFAME_EXTRA_INLINE=__inline__ -DINLINE=__inline__ -DFAME_NO_RESTORE_PC_MASKED_BITS
src/m68k/fame/famec.o: src/m68k/fame/famec.cpp
OBJS += src/m68k/fame/famec.o src/m68k/fame/m68k_intrf.o
else
OBJS += \
	src/m68k/uae/newcpu.o \
	src/m68k/uae/readcpu.o \
	src/m68k/uae/cpudefs.o \
	src/m68k/uae/fpp.o \
	src/m68k/uae/cpustbl.o \
	src/m68k/uae/cpuemu.o

endif

CPPFLAGS  = $(CFLAGS)

$(PROG): $(OBJS) 
	$(CC) $(CFLAGS) -o $(PROG) $(OBJS) $(LDFLAGS)
	$(STRIP) $(PROG)


run: $(PROG)
	./$(PROG)

ipk: $(PROG)
	@mkdir -p $(RELEASEDIR)
	@rm -rf /tmp/.uae4all-ipk/ && mkdir -p /tmp/.uae4all-ipk/root/home/retrofw/emus/uae4all /tmp/.uae4all-ipk/root/home/retrofw/apps/gmenu2x/sections/emulators /tmp/.uae4all-ipk/root/home/retrofw/apps/gmenu2x/sections/emulators.systems
	@cp -R $(DATADIR) ./docs/ /tmp/.uae4all-ipk/root/home/retrofw/emus/uae4all
	@rm /tmp/.uae4all-ipk/root/home/retrofw/emus/uae4all/$(DATADIR)/music.mod /tmp/.uae4all-ipk/root/home/retrofw/emus/uae4all/$(DATADIR)/click.wav
	@cp $(PROG) $(OPKDIR)/uae4all.png $(OPKDIR)/readme.man.txt /tmp/.uae4all-ipk/root/home/retrofw/emus/uae4all
	@cp $(OPKDIR)/uae4all.lnk /tmp/.uae4all-ipk/root/home/retrofw/apps/gmenu2x/sections/emulators
	@cp $(OPKDIR)/amiga.uae4all.lnk /tmp/.uae4all-ipk/root/home/retrofw/apps/gmenu2x/sections/emulators.systems
	@sed "s/^Version:.*/Version: $$(date +%Y%m%d)/" $(OPKDIR)/control > /tmp/.uae4all-ipk/control
	@cp $(OPKDIR)/conffiles /tmp/.uae4all-ipk/
	@tar --owner=0 --group=0 -czvf /tmp/.uae4all-ipk/control.tar.gz -C /tmp/.uae4all-ipk/ control conffiles
	@tar --owner=0 --group=0 -czvf /tmp/.uae4all-ipk/data.tar.gz -C /tmp/.uae4all-ipk/root/ .
	@echo 2.0 > /tmp/.uae4all-ipk/debian-binary
	@ar r $(RELEASEDIR)/uae4all.ipk /tmp/.uae4all-ipk/control.tar.gz /tmp/.uae4all-ipk/data.tar.gz /tmp/.uae4all-ipk/debian-binary

opk: $(PROG)
	mkdir -p $(RELEASEDIR)
	cp $(PROG) $(RELEASEDIR)
	cp -R $(DATADIR) $(RELEASEDIR)
	rm $(RELEASEDIR)/$(DATADIR)/music.mod
	rm $(RELEASEDIR)/$(DATADIR)/click.wav
	cp $(OPKDIR)/default.gcw0.desktop $(OPKDIR)/readme.man.txt $(OPKDIR)/uae4all.png $(RELEASEDIR)
	cp -R ./docs/ $(RELEASEDIR)
	mksquashfs $(RELEASEDIR) uae4all.opk -all-root -noappend -no-exports -no-xattrs

almostclean:
	cp src/m68k/fame/famec.o src/m68k/fame/famec.preserved.o
	$(RM) $(PROG) $(OBJS)
	mv src/m68k/fame/famec.preserved.o src/m68k/fame/famec.o

clean:
	$(RM) $(PROG) $(OBJS)
	rm -rf $(RELEASEDIR)
