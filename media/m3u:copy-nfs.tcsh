#!/bin/tcsh -f
if( ${?1} && "${1}" != "" && "${1}" == "--debug" ) then
	shift;
	if(! ${?TCSH_RC_DEBUG} ) \
		setenv TCSH_RC_DEBUG "`basename ${0}`";
endif

if( ! ( ${?1} && "${1}" != "" && "`printf "\""${1}"\"" | sed 's/.*\(\.m3u\)"\$"/\1/'`" == ".m3u" && -e "${1}" ) ) then
	if( "`printf "\""${1}"\"" | sed 's/.*\(\.m3u\)"\$"/\1/'`" != ".m3u" ) printf "\n\t**ERROR:** %s is not a valid m3u playlist.\n" "${1}";
	printf "Usage: %s playlist.m3u (e.g: ~/media/playlist/filename.m3u)\n" "`basename '${0}'`";
	exit -1;
endif

if(!( ${?2} && "${2}" != "" && ( "`printf "\""${2}"\"" | sed 's/.*\(\.tcsh\)"\$"/\1/g'`" == ".tcsh" || "${2}" == "--enable=auto-copy" ) )) then
	set tcsh_shell_script="`printf "\""${1}"\"" | sed 's/\(.*\)\([^\/]\+\)\(\.m3u\)"\$"/\1\2\.tcsh/'`";
else if( "${2}" == "--enable=auto-copy" ) then
	set auto_copy;
	set tcsh_shell_script="./.copy-local-@-`date '+%s'`";
else
	set tcsh_shell_script="${2}";
endif
if( "${1}" == "${tcsh_shell_script}" ) then
	printf "Failed to generate tcsh script filename.";
	exit -1;
endif

if(! ${?auto_copy} ) then
	printf "Converting %s to %s" "${1}" "${tcsh_shell_script}";
else
	printf "Preparing to copy contents of %s" "${1}";
endif

alias	ex	"ex -E -n -X --noplugin";

/bin/cp "${1}" "./.local.playlist.swp";
ex -s '+1,$s/^[^\/].*[\r\n]*//' '+1,$s/\([\"\$\!]\)/\"\\\1\"/g' '+wq!' "./.local.playlist.swp";

printf '#\!/bin/tcsh -f\nset old_podcast="";\n' >! "${tcsh_shell_script}";
chmod u+x "${tcsh_shell_script}";
ex -s "+2r ./.local.playlist.swp" '+wq!' "${tcsh_shell_script}";
/bin/rm "./.local.playlist.swp";

ex -s '+3,$s/\v^(\/[^\/]+\/[^\/]+\/)(.*)\/(.*)(\..*)$/if\(\! -e "\1nfs\/\2\/\3\4" \) then\r\t\techo "**error coping:** remote file \<\1nfs\/\2\/\3\4\> doesn'\''t exists." \> \/dev\/stderr;\r\telse\r\tif\(\!  -d "\1\2" \) mkdir -fp "\1\2";\r\tif\(\! -e "\1\2\/\3\4" \) then\r\t\tif\( "${old_podcast}" \!\=   "\2" \) then\r\t\t\tset old_podcast\="\2";\r\t\t\techo "\\nCopying: ${old_podcast}'\''s content(s)  :";\r\t\tendif\r\t\techo "\\n\\tCopying: \3\4";\r\t\tcp "\1nfs\/\2\/\3\4" "\1\2\/\3\4"\r\t\techo "  \\n\\t\\t\\t[done]\\n";\r\tendif\rendif\r/' '+wq' "${tcsh_shell_script}";
#3,$s/^\(\/[^\/]\+\/[^\/]\+\/\)\(.*\)\(\.[^\.]\+\)$/if(! -e "\1nfs\/\2\3" ) then\r\t\tprintf "**error coping:** remote file <%s> doesn't exists." "\1nfs\/\2\3" > \/dev\/stderr;\r\telse\r\t\tset podcast_dir="`dirname "\\\""\1\2\3"\\\""`";\r\t\tif(! -d "\${podcast_dir}" ) mkdir -p "\${podcast_dir}";\r\t\tif(! -e "\1\2\3" ) then\r\t\t\tif( "\${old_podcast}" != "`basename "\\\""\${podcast_dir}"\\\""`" ) then\r\t\t\t\tset old_podcast="`basename "\\\""\${podcast_dir}"\\\""`";\r\t\t\t\tprintf "\\nCopying: %s's content(s):" "\${old_podcast}";\r\t\t\tendif\r\t\tprintf "\\n\\tCopying: %s" "` basename "\\\""\1\2\3"\\\"" | sed -r "\\""s\/(.*)(\\.[^\\.])\$\/\\1\/"\\""`";\r\t\tcp "\1nfs\/\2\3 " "\1\2\3"\r\t\tprintf "\\n\\t\\t\\t[done]\\n";\r\tendif\rendif\r/

printf "\t[done]\n";

if( ${?auto_copy} ) then
	printf "\nCopying nfs files to local directory.\n";
	"${tcsh_shell_script}";
	/bin/rm "${tcsh_shell_script}";
endif

if( ${?TCSH_RC_DEBUG} ) then
	if( "${TCSH_RC_DEBUG}" == "`basename '${0}'`" ) \
		unsetenv TCSH_RC_DEBUG;
endif

