#!/bin/tcsh -f

alias	"./configure"	"./configure --libdir=/usr/lib64"
alias	"./autogen.sh"	"./autogen.sh --libdir=/usr/lib64"

#alias make 'if ( ${?GREP_OPTIONS} ) set grep_options="${GREP_OPTIONS}";\
#	if( ${?GREP_OPTIONS} ) unsetenv $GREP_OPTIONS; make'

#C compiler linking flags
#	libraries to pass to the linker.
#		-l<library>, e.g. -lpango-1.0
#	or shared objects directly:
#		-L<library.path.so>, e.g. -L/usr/lib64/libpango-1.0.so
#setenv	LDFLAGS		"-L/lib64 -L/usr/lib64 -L/usr/lib -L/lib -L/usr/X11R6/lib64/Xaw3d -L/usr/X11R6/lib64 -L/usr/lib64/Xaw3d -L/usr/X11R6/lib/Xaw3d -L/usr/X11R6/lib -L/usr/lib/Xaw3d -L/usr/x86_64-suse-Linux/lib -L/usr/local/lib -L/opt/kde3/lib -L/usr/local/lib64 -L/opt/kde3/lib64"
#setenv	LIBS		"-L/lib64 -L/usr/lib64 -L/usr/lib -L/lib -L/usr/X11R6/lib64/Xaw3d -L/usr/X11R6/lib64 -L/usr/lib64/Xaw3d -L/usr/X11R6/lib/Xaw3d -L/usr/X11R6/lib -L/usr/lib/Xaw3d -L/usr/x86_64-suse-Linux/lib -L/usr/local/lib -L/opt/kde3/lib -L/usr/local/lib64 -L/opt/kde3/lib64"


setenv	LD_LIBRARY_PATH		"/usr/include"
setenv	LD_RUN_PATH		"/usr/include"


#C compiler command
setenv	CC		"/usr/bin/gcc"

#C preprocessor
setenv	CPP		"/usr/bin/cpp"

#C/C++/Objective C preprocessor flags, e.g. -I<include dir> if
#you have headers in a nonstandard directory <include dir>
setenv	CPPFLAGS	"-I${LD_LIBRARY_PATH}"

setenv	MAKEFLAGS	"-O3 -Wall -Wextra -Wstrict-aliasing=3 -Wformat=2 -Werror -Wno-unused-parameter"

setenv	MYFLAGS		"${MAKEFLAGS} -Wfatal-errors -Wswitch-enum -Wno-missing-field-initializers --combine"
setenv	MYCFLAGS	"${MYFLAGS} -Wmissing-prototypes"
setenv	MYCXXFLAGS	"${MYFLAGS}"


setenv	CFLAGS		"-std=gnu99 ${MYCFLAGS} ${CPPFLAGS}"

setenv	CXXFLAGS	"-std=gnu++0x ${MYCXXFLAGS} ${CPPFLAGS}"

#Path to xmkmf, Makefile generator for X Window System
setenv	XMKMF		"/usr/bin/xmkmf"

