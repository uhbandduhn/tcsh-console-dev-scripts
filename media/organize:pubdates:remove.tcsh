#!/bin/tcsh -f
if(! ${?0} ) then
	printf "This script cannot be sourced and must be executed.\n" > /dev/stderr;
	set status=-501;
	exit ${status};
endif

while( "${1}" != "" )
	switch( "${1}" )
		case "--keep-pubdate":
			set keep_pubdate;
			breaksw;
		
		default:
			if( ! ${?target_directory} && -d "${1}" ) then
				set target_directory="${1}";
				breaksw;
			endif
			
			printf "%s is an unsupported option.\n" > /dev/stderr;
			breaksw;
	endsw
	shift;
end

if(! ${?target_directory} ) then
	printf "Usage: %s [directory]", "`basename ${0}`";
	set status=-502;
	exit ${status};
endif

foreach title("`/usr/bin/find -L "\""${target_directory}"\"" -regextype posix-extended -iregex '.*, released on.*\.([^\.]*)"\$"' -type f | sort | sed -r 's/(["\"\$\!\`"])/"\""\\\1"\""/g'`")
	set file_path="`printf "\""%s"\"" "\""${title}"\"" | sed -r 's/^(.*)\/(.*)(,\ released\ on\:\ )([^\.]+)\.([^\.]+)/\1/g'`";
	set file_name="`printf "\""%s"\"" "\""${title}"\"" | sed -r 's/^(.*)\/(.*)(,\ released\ on\:\ )([^\.]+)\.([^\.]+)/\2/g'`";
	set extension="`printf "\""%s"\"" "\""${title}"\"" | sed -r 's/^(.*)\/(.*)(,\ released\ on\:\ )([^\.]+)\.([^\.]+)/\5/g'`";
	set title="`printf "\""%s"\"" "\""${title}"\""`";
	mv -v "${title}" "${file_path}/${file_name}.${extension}";
end

