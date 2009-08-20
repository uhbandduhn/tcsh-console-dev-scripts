#!/bin/tcsh -f
cd "`dirname '${0}'`";

set search_script="`dirname '${0}'`/gPodder:Search:index.rss.tcsh";

if(!( ${?1} && "${1}" != "" && "${1}" != "--help" )) then
	printf "%s uses %s to find what episodes to redownload.\n\tIt supports all of its options in addition to:\n\t\t--quiet\t-Which cause the wget ouptput to be surpressed.\t\n\t\n\tIn addition %s' options are:\n\t" `basename ${0}` ${search_script} ${search_script};
	${search_script} --help
	exit -1;
endif

set silent="";
if( ${?1} && ( "${1}" == "--silent" || "${1}" == "--quiet" ) ) then
	set silent=">& /dev/null";
	shift;
endif

set mp3_player_folder="`grep 'mp3_player_folder' '${HOME}/.config/gpodder/gpodder.conf' | cut -d= -f2 | cut -d' ' -f2`";

cd "${mp3_player_folder}";
set search_attribute="`echo "\""${1}"\"" | sed 's/\(\-\-[^=]\+\)=\(.*\)/\1/'`";
set search_value="`echo "\""${1}"\"" | sed 's/\(\-\-[^=]\+\)=\(.*\)/\2/'`";

foreach podcast_match( "`${search_script} '${1}' | cut -d':' -f2 | sed 's/\\!//'`" )
	set refetch_script="${mp3_player_folder}/gPodder:Refetch:`echo '${podcast_match}' | sed 's/\([\-\=\/\*\?\.\[\]()]\+\)/\:/g'`.tcsh";
	
	${search_script} --verbose ${search_attribute}="${podcast_match}" >! "${refetch_script}.tmp";
	ex -E '+1,$s/[\r\n]\+//g' '+s/\(<\/item>\)/\1\n/g' '+s/#//g' '+1,$s/.*<title>\([^>]\+\)<\/title>.*<title>\([^<]\+\)<\/title>.*<url>\([^<]\+\)<\/url>.*/if ( -d "\1" ) then\relse\r\tmkdir "\1"\rendif\rwget -c -O "\1\/\2" "\3"/g' '+2,$s/^\(wget\ \-c\ \-O\ \)\"\([^\"]\+\)\"\ \"\([^\"]\+\)\.\([^\.\"]\+\)\"$/\1\ \"\2\.\4\"\ \3\.\4/' '+1,$s/\!//g' '+wq' "${refetch_script}.tmp" >& /dev/null;
	
	while ( `/usr/bin/grep --perl-regexp -e '("[^\/]+)\/(.*)"' "${refetch_script}.tmp"` != "" )
		ex -E '+1,$s/\("[^\/]\+\)\/\(.*"\)/\1\-\2/g' '+wq' "${refetch_script}.tmp" >& /dev/null;
	end
	
	set podcast_dir=`head -3 "${refetch_script}.tmp" | tail -1 | sed 's/.*mkdir "\([^"]\+\)"/\1/'`;
	ex -E '+4,$s/\('"${podcast_dir}"'\)\-/\1\//g' '+wq' "${refetch_script}.tmp";
	
	if( `wc -l "${refetch_script}.tmp" | sed 's/^\([0-9]\+\)\ .*/\1/g'` > 0 ) then
		printf '#\!/bin/tcsh -f\n' >! "${refetch_script}";
		cat "${refetch_script}.tmp" >> "${refetch_script}";
		chmod +x "${refetch_script}";
		"${refetch_script}" ${silent};
		if( ${status} == 0 ) rm "${refetch_script}";
	endif
	rm "${refetch_script}.tmp";
end