#!/bin/sh

if [ ! -f "/var/lib/dpkg/info/libudev1:amd64.list" ]; then
	echo "Please install libudev1 package, run "
	echo "\"sudo apt-get install libudev1\""
	exit 1
fi

if [ "$QUARTUS_ROOTDIR" = "" ]; then
	echo "Please set QUARTUS_ROOTDIR shell variable to the"
	echo "Quartus installation directory"
	exit 1
fi

if [ ! -d "${QUARTUS_ROOTDIR}/linux64" ]; then
	echo "Quartus directory \"$QUARTUS_ROOTDIR\""
	echo "does not contain \"linux64\" subdirectory"
	exit 1
fi

srcfile=$(grep -E '/libudev.so.1$' "/var/lib/dpkg/info/libudev1:amd64.list")
dstfile="${QUARTUS_ROOTDIR}/linux64/libudev.so.0"

if [ ! -f "$srcfile" ]; then
	echo "File \"${srcfile}\" does not exist despite being listed"
	echo "in the installed package"
	exit 1
fi

if [ -f "$dstfile" ]; then
	echo "File \"${dstfile}\" is already installed"
	exit 1
fi

ln -s "$srcfile" "$dstfile"
killall jtagd 2>/dev/null
