#!/bin/tcsh -f
if( -e /tmp/tmp-search.log ) rm -f /tmp/tmp-search.log
printf "Please wait while all tmp files and directories are found.\nThis *will* take several minutes.\n"
( find / -perm -1000 -perm /0200 >! /tmp/tmp-search.log ) > & /dev/null
printf "Please wait while I clean-up tmp files.  This will take much less time but may take a few moments.\n"
foreach tmp ( "`cat /tmp/tmp-search.log`" )
	if( ! -w "${tmp}" ) continue
	if( -d "${tmp}" ) rm -r "${tmp}/*" ; continue
	if( -e "${tmp}" ) rm "${tmp}" ; continue
end
if( -e /tmp/tmp-search.log ) rm -f /tmp/tmp-search.log

