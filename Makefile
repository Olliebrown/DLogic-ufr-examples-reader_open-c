####################################################################
# Digital Logic
# www.d-logic.net
#
# s
####################################################################
$(VERBOSE).SILENT:
####################################################################

OUTNAME = uFReader-open

LIBNAME = uFCoder
LIBDIR = lib

SRC = src/*.c

####################################################################
####################################################################

all : info_ver help

info_ver :
	echo "---------------------------------------------------------"
	echo "  Making example to test the uFReader opening"
	echo ""
	echo "  Project output name: $(OUTNAME)"
	echo "---------------------------------------------------------"

####################################################################

help : 
	echo "--------------+------------------------------------"
	echo "   Execute    | for building executables on Operating System / platform"
	echo "--------------+------------------------------------"
	echo " make win64   | Windows x86_64"
	echo " make win32   | Windows x86"
	echo " make macos   | macOS x86_64"
	echo " make lin64   | Linux x86_64"
	echo " make lin32   | Linux x86"
	echo " make armhf   | Linux ARM - Hard Point"
	echo " make armel   | Linux ARM - Soft Point"
	echo " make aarch64 | Linux ARM - aarch64"
	echo "---------------------------------------------------"

####################################################################
####################################################################

INCLUDES = -I$(LIBDIR)/include

CFLAGS = $(INCLUDES) # -static-libgcc # -static-libstdc++

CC = gcc

#-------------------------------------------------------------------
#-------------------------------------------------------------------

win64 :
	-mkdir windows-x86_64-release
	# help on error
	echo "If You see error like: '$(LIBDIR)/windows/x86_64/$(LIBNAME)-x86_64.dll: file not recognized: File format not recognized'"
	echo "  This means You have the GCC compiler for 32 bit"
	echo "  type 'make win32' instead of 'make win64'"
	echo ""
	# compile
	$(CC) -o windows-x86_64-release/$(OUTNAME) $(CFLAGS) $(SRC) -L$(LIBDIR)/windows/x86_64/ -l$(LIBNAME)-x86_64
	# done
	echo "Making on 64-bit Windows is done - without errors."
	echo "Output is in windows-x86_64-release/"
	echo
	# running help message
	echo "You must use library from the '$(LIBDIR)\windows\x86_64\'"
	echo ""
	echo "To run the example - type:"
	echo "   'cd windows-x86_64-release'"
	echo "   'run_me'"

#-------------------------------------------------------------------

win32 :
	-mkdir windows-x86-release
	# help on error
	echo "If You see error like: 'skipping incompatible $(LIBDIR)/windows/x86/$(LIBNAME)-x86.dll when searching for...'"
	echo "  This means You have the GCC compiler for 64 bit"
	echo "  type 'make win64' instead of 'make win32'"
	echo ""
	# compile
	$(CC) -o windows-x86-release/$(OUTNAME) $(CFLAGS) $(SRC) -L$(LIBDIR)/windows/x86/ -l$(LIBNAME)-x86 -Wl,--enable-stdcall-fixup
	# done
	echo "Making on 32-bit Windows is done - without errors."
	echo "Output is in windows-x86-release/"
	echo
	# running help message
	echo "You must use library from the '$(LIBDIR)\windows\x86\'"
	echo ""
	echo "To run the example - type:"
	echo "   'cd windows-x86-release'"
	echo "   'run_me'"

#-------------------------------------------------------------------
#-------------------------------------------------------------------

macos osx :
	-mkdir -p macos-x86_64-release
	$(CC) -o macos-x86_64-release/$(OUTNAME) $(CFLAGS) $(SRC) -L$(LIBDIR)/macos/x86_64 -l$(LIBNAME)-x86_64 -Xlinker -rpath $(LIBDIR)/macos/x86_64/
	echo "Making on 64-bit Intel macOS is done - without errors."
	echo "Output is in macos-x86_64-release/"
	echo
	# running help message
	echo "You must use library from the '$(LIBDIR)/macos/x86_64'"
	echo ""
	echo "To run the example - type:"
	echo "   'cd macos-x86_64-release && ./$(OUTNAME)'"

#-------------------------------------------------------------------
#-------------------------------------------------------------------

lin64 :
	-mkdir -p linux-x86_64-release
	$(CC) -m64 -o linux-x86_64-release/$(OUTNAME) $(CFLAGS) $(SRC) -L$(LIBDIR)/linux/x86_64/ -l$(LIBNAME)-x86_64 -Wl,-R../$(LIBDIR)/linux/x86_64/
	echo "Making on 64-bit x86 Linux is done - without errors."
	echo "Output is in linux-x86_64-release/"
	echo
	# running help message
	echo "You must use library from the '$(LIBDIR)/linux/x86_64'"
	echo ""
	echo "To run the example - type:"
	echo "   'cd linux-x86_64-release && ./$(OUTNAME)'"

#-------------------------------------------------------------------

lin32 :
	-mkdir -p linux-x86-release
	$(CC) -m32 -o linux-x86-release/$(OUTNAME) $(CFLAGS) $(SRC) -L$(LIBDIR)/linux/x86/ -l$(LIBNAME)-x86 -Wl,-R../$(LIBDIR)/linux/x86/
	echo "Making on 32-bit x86 Linux is done - without errors."
	echo "Output is in linux-x86-release/"
	echo
	# running help message
	echo "You must use library from the '$(LIBDIR)/linux/x86'"
	echo ""
	echo "To run the example - type:"
	echo "   'cd linux-x86-release && ./$(OUTNAME)'"

#-------------------------------------------------------------------

armhf :
	-mkdir -p linux-arm-hf-release
	$(CC) -o linux-arm-hf-release/$(OUTNAME) $(CFLAGS) $(SRC) -L$(LIBDIR)/linux/arm-hf/ -l$(LIBNAME)-armhf -Wl,-R../$(LIBDIR)/linux/arm-hf/
	echo "Making on ARM-HF Linux is done - without errors."
	echo "Output is in linux-arm-hf-release/"
	echo
	# running help message
	echo "You must use library from the '$(LIBDIR)/linux/arm-hf'"
	echo ""
	echo "To run the example - type:"
	echo "   'cd linux-arm-hf-release && ./$(OUTNAME)'"

#-------------------------------------------------------------------

armel :
	-mkdir -p linux-arm-el-release
	$(CC) -o linux-arm-el-release/$(OUTNAME) $(CFLAGS) $(SRC) -L$(LIBDIR)/linux/arm-el/ -l$(LIBNAME)-armel -Wl,-R../$(LIBDIR)/linux/arm-el/
	echo "Making on ARM-EL Linux is done - without errors."
	echo "Output is in linux-arm-el-release/"
	echo
	# running help message
	echo "You must use library from the '$(LIBDIR)/linux/arm-el'"
	echo ""
	echo "To run the example - type:"
	echo "   'cd linux-arm-el-release && ./$(OUTNAME)'"

#-------------------------------------------------------------------

aarch64 :
	-mkdir -p linux-aarch64-release
	$(CC) -o linux-aarch64-release/$(OUTNAME) $(CFLAGS) $(SRC) -L$(LIBDIR)/linux/aarch64/ -l$(LIBNAME)-aarch64 -Wl,-R../$(LIBDIR)/linux/aarch64/
	echo "Making on AARCH64 Linux is done - without errors."
	echo "Output is in linux-aarch64-release/"
	echo
	# running help message
	echo "You must use library from the '$(LIBDIR)/linux/aarch64'"
	echo ""
	echo "To run the example - type:"
	echo "   'cd linux-aarch64-release && ./$(OUTNAME)'"

#-------------------------------------------------------------------

####################################################################
