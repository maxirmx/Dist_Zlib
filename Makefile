# Makefile for zlib using Microsoft (Visual) C
# zlib is copyright (C) 1995-2017 Jean-loup Gailly and Mark Adler
#
# Usage:
#   nmake -f win32/Makefile.msc                          (standard build)
#   nmake -f win32/Makefile.msc LOC=-DFOO                (nonstandard build)
#   nmake -f win32/Makefile.msc LOC="-DASMV -DASMINF" \
#         OBJA="inffas32.obj match686.obj"               (use ASM code, x86)
#   nmake -f win32/Makefile.msc AS=ml64 LOC="-DASMV -DASMINF -I." \
#         OBJA="inffasx64.obj gvmat64.obj inffas8664.obj"  (use ASM code, x64)

# The toplevel directory of the source tree.
#
TOP = .

# optional build flags
LOC =

# variables
STATICLIB = zlib.lib
SHAREDLIB = zlib1.dll
IMPLIB    = zdll.lib

CC = cl
AS = ml
LD = link
AR = lib
RC = rc
CFLAGS  = -nologo -W3 -Oy- -Zi $(LOC)
WFLAGS  = -D_CRT_SECURE_NO_DEPRECATE -D_CRT_NONSTDC_NO_DEPRECATE
ASFLAGS = -coff -Zi $(LOC)
LDFLAGS = -nologo -debug -incremental:no -opt:ref
ARFLAGS = -nologo
RCFLAGS = /dWIN32 /r

OBJS = adler32.obj compress.obj crc32.obj deflate.obj gzclose.obj gzlib.obj gzread.obj \
       gzwrite.obj infback.obj inflate.obj inftrees.obj inffast.obj trees.obj uncompr.obj zutil.obj
OBJA =


# targets
all: $(STATICLIB) $(SHAREDLIB) $(IMPLIB) \
     example.exe minigzip.exe

$(STATICLIB): $(OBJS) $(OBJA)
	$(AR) $(ARFLAGS) -out:$@ $(OBJS) $(OBJA)

$(IMPLIB): $(SHAREDLIB)

$(SHAREDLIB): $(TOP)/win32/zlib.def $(OBJS) $(OBJA) zlib1.res
	$(LD) $(LDFLAGS) -def:$(TOP)/win32/zlib.def -dll -implib:$(IMPLIB) \
	  -out:$@ -base:0x5A4C0000 $(OBJS) $(OBJA) zlib1.res
	if exist $@.manifest \
	  mt -nologo -manifest $@.manifest -outputresource:$@;2

example.exe: example.obj $(STATICLIB)
	$(LD) $(LDFLAGS) example.obj $(STATICLIB)
	if exist $@.manifest \
	  mt -nologo -manifest $@.manifest -outputresource:$@;1

minigzip.exe: minigzip.obj $(STATICLIB)
	$(LD) $(LDFLAGS) minigzip.obj $(STATICLIB)
	if exist $@.manifest \
	  mt -nologo -manifest $@.manifest -outputresource:$@;1

example_d.exe: example.obj $(IMPLIB)
	$(LD) $(LDFLAGS) -out:$@ example.obj $(IMPLIB)
	if exist $@.manifest \
	  mt -nologo -manifest $@.manifest -outputresource:$@;1

minigzip_d.exe: minigzip.obj $(IMPLIB)
	$(LD) $(LDFLAGS) -out:$@ minigzip.obj $(IMPLIB)
	if exist $@.manifest \
	  mt -nologo -manifest $@.manifest -outputresource:$@;1

{$(TOP)}.c.obj:
	$(CC) -c $(WFLAGS) $(CFLAGS) $<

{$(TOP)/test}.c.obj:
	$(CC) -c -I$(TOP) $(WFLAGS) $(CFLAGS) $<

{$(TOP)/contrib/masmx64}.c.obj:
	$(CC) -c $(WFLAGS) $(CFLAGS) $<

{$(TOP)/contrib/masmx64}.asm.obj:
	$(AS) -c $(ASFLAGS) $<

{$(TOP)/contrib/masmx86}.asm.obj:
	$(AS) -c $(ASFLAGS) $<

adler32.obj: $(TOP)/adler32.c $(TOP)/zlib.h $(TOP)/zconf.h

compress.obj: $(TOP)/compress.c $(TOP)/zlib.h $(TOP)/zconf.h

crc32.obj: $(TOP)/crc32.c $(TOP)/zlib.h $(TOP)/zconf.h $(TOP)/crc32.h

deflate.obj: $(TOP)/deflate.c $(TOP)/deflate.h $(TOP)/zutil.h $(TOP)/zlib.h $(TOP)/zconf.h

gzclose.obj: $(TOP)/gzclose.c $(TOP)/zlib.h $(TOP)/zconf.h $(TOP)/gzguts.h

gzlib.obj: $(TOP)/gzlib.c $(TOP)/zlib.h $(TOP)/zconf.h $(TOP)/gzguts.h

gzread.obj: $(TOP)/gzread.c $(TOP)/zlib.h $(TOP)/zconf.h $(TOP)/gzguts.h

gzwrite.obj: $(TOP)/gzwrite.c $(TOP)/zlib.h $(TOP)/zconf.h $(TOP)/gzguts.h

infback.obj: $(TOP)/infback.c $(TOP)/zutil.h $(TOP)/zlib.h $(TOP)/zconf.h $(TOP)/inftrees.h $(TOP)/inflate.h \
             $(TOP)/inffast.h $(TOP)/inffixed.h

inffast.obj: $(TOP)/inffast.c $(TOP)/zutil.h $(TOP)/zlib.h $(TOP)/zconf.h $(TOP)/inftrees.h $(TOP)/inflate.h \
             $(TOP)/inffast.h

inflate.obj: $(TOP)/inflate.c $(TOP)/zutil.h $(TOP)/zlib.h $(TOP)/zconf.h $(TOP)/inftrees.h $(TOP)/inflate.h \
             $(TOP)/inffast.h $(TOP)/inffixed.h

inftrees.obj: $(TOP)/inftrees.c $(TOP)/zutil.h $(TOP)/zlib.h $(TOP)/zconf.h $(TOP)/inftrees.h

trees.obj: $(TOP)/trees.c $(TOP)/zutil.h $(TOP)/zlib.h $(TOP)/zconf.h $(TOP)/deflate.h $(TOP)/trees.h

uncompr.obj: $(TOP)/uncompr.c $(TOP)/zlib.h $(TOP)/zconf.h

zutil.obj: $(TOP)/zutil.c $(TOP)/zutil.h $(TOP)/zlib.h $(TOP)/zconf.h

gvmat64.obj: $(TOP)/contrib\masmx64\gvmat64.asm

inffasx64.obj: $(TOP)/contrib\masmx64\inffasx64.asm

inffas8664.obj: $(TOP)/contrib\masmx64\inffas8664.c $(TOP)/zutil.h $(TOP)/zlib.h $(TOP)/zconf.h \
		$(TOP)/inftrees.h $(TOP)/inflate.h $(TOP)/inffast.h

inffas32.obj: $(TOP)/contrib\masmx86\inffas32.asm

match686.obj: $(TOP)/contrib\masmx86\match686.asm

example.obj: $(TOP)/test/example.c $(TOP)/zlib.h $(TOP)/zconf.h

minigzip.obj: $(TOP)/test/minigzip.c $(TOP)/zlib.h $(TOP)/zconf.h

zlib1.res: $(TOP)/win32/zlib1.rc
	$(RC) $(RCFLAGS) /fo$@ $(TOP)/win32/zlib1.rc

# testing
test: example.exe minigzip.exe
	example
	echo hello world | minigzip | minigzip -d

testdll: example_d.exe minigzip_d.exe
	example_d
	echo hello world | minigzip_d | minigzip_d -d


# cleanup
clean:
	-del $(STATICLIB)
	-del $(SHAREDLIB)
	-del $(IMPLIB)
	-del *.obj
	-del *.res
	-del *.exp
	-del *.exe
	-del *.pdb
	-del *.manifest
	-del foo.gz
