#!/bin/tcsh -f
set label_current="init";
goto label_stack_set;
init:
	set label_current="init";
	if( "${label_current}" != "${label_previous}" ) \
		goto label_stack_set;
	set strict;
	set original_owd=${owd};
	set starting_dir=${cwd};
	set escaped_starting_dir=${escaped_cwd};
	
	if(! $?0 ) \
		set being_sourced;
	
	set script_basename="pls-tox-m3u:find:removed:files.tcsh";
	set script_alias="`printf '%s' '${script_basename}' | sed -r 's/(.*)\.(tcsh|cshrc)"\$"/\1/'`";
	
	#set escaped_starting_dir="`printf "\""%s"\"" "\""${cwd}"\"" | sed -r 's/\//\\\//g' | sed -r 's/(["\""])/"\""\\"\"""\""/g' | sed -r 's/(["\$"])/"\""\\"\$""\""/g' | sed -r 's/(['\!'])/\\\1/g' | sed -r 's/(\[)/\\\1/g' | sed -r 's/([*])/\\\1/g'`";
	set escaped_home_dir="`printf "\""%s"\"" "\""${HOME}"\"" | sed -r 's/\//\\\//g' | sed -r 's/(["\""])/"\""\\"\"""\""/g' | sed -r 's/(["\$"])/"\""\\"\$""\""/g' | sed -r 's/(['\!'])/\\\1/g' | sed -r 's/(\[)/\\\1/g' | sed -r 's/([*])/\\\1/g'`";
	#if(! -d "`printf "\""${escaped_home_dir}"\"" | sed -r 's/\\(\[)/\1/g' | sed -r 's/\\([*])/\1/g'`" ) then
	#	set home_files=();
	#else
	#	set home_files="`/bin/ls "\""${escaped_home_dir}"\""`";
	#endif
	
	if( "`alias cwdcmd`" != "" ) then
		set oldcwdcmd="`alias cwdcmd`";
		unalias cwdcmd;
	endif
	
	@ errno=0;
	
	#set supports_being_source;
	#set argz="";
	#set script_supported_extensions="mp3|ogg|m4a";
	
	alias	ex	"ex -E -X -n --noplugin -s";
	
	#set download_command="curl";
	#set download_command_with_options="${download_command} --location --fail --show-error --silent --output";
	#alias	"curl"	"${download_command_with_options}";
	
	#set download_command="wget";
	#set download_command_with_options="${download_command} --no-check-certificate --quiet --continue --output-document";
	#alias	"wget"	"${download_command_with_options}";
	
	goto parse_argv;
#init:

init_complete:
	set label_current="init_complete";
	if( "${label_current}" != "${label_previous}" ) \
		goto label_stack_set;
	set init_completed;
#init_complete:

check_dependencies:
	set label_current="check_dependencies";
	if( "${label_current}" != "${label_previous}" ) \
		goto label_stack_set;
	
	set dependencies=("${script_basename}");# "${script_alias}");
	@ dependencies_index=0;
#check_dependencies:


check_dependencies:
	set label_current="check_dependencies";
	if( "${label_current}" != "${label_previous}" ) \
		goto label_stack_set;
	
	foreach dependency(${dependencies})
		@ dependencies_index++;
		unset dependencies[$dependencies_index];
		foreach dependency("`where '${dependency}'`")
			if( ${?debug} ) \
				printf "\n**%s debug:** looking for dependency: %s.\n\n" "${script_basename}" "${dependency}"; 
			
			if(! -x "${dependency}" ) \
				continue;
			
			if(! ${?script_dirname} ) then
				if("`basename '${dependency}'`" == "${script_basename}" ) then
					set old_owd="${cwd}";
					cd "`dirname '${dependency}'`";
					set script_dirname="${cwd}";
					cd "${owd}";
					set owd="${old_owd}";
					unset old_owd;
					set script="${script_dirname}/${script_basename}";
					if(! ${?TCSH_RC_SESSION_PATH} ) \
						setenv TCSH_RC_SESSION_PATH "${script_dirname}/../tcshrc";
					
					if(! ${?TCSH_LAUNCHER_PATH} ) \
						setenv TCSH_LAUNCHER_PATH \$"{TCSH_RC_SESSION_PATH}/../launchers";
				endif
			endif
			
			if( ${?debug} )	then
				switch( "`printf '%s' '${dependencies_index}' | sed -r 's/.*([1-3])"\$"/\1/'`" )
					case "1":
						set suffix="st";
						breaksw;
					
					case "2":
						set suffix="nd";
						breaksw;
					
					case "3":
						set suffix="rd";
						breaksw;
					
					default:
						set suffix="th";
						breaksw;
				endsw
				
				printf "\n**%s debug:** found %d%s dependency: %s.\n\n" "${script_basename}" $dependencies_index "$suffix" "${dependency}";
				unset suffix;
			endif
			
			switch("${dependency}")
				case "${script_basename}":
				case "./${dependency}":
				case "${TCSH_LAUNCHER_PATH}/${dependency}":
					continue;
					breaksw;
			endsw
			break;
		end
		
		if(! ${?program} ) \
			set program="${script}";
		
		if(!( ${?dependency} && ${?script} && ${?program} )) then
			set missing_dependency;
		else
			if(!( -x ${script} && -x ${dependency} && -x ${program} )) \
				set missing_dependency;
		endif
		
		if( ${?missing_dependency} ) then
			@ errno=-501;
			goto exception_handler;
		endif
		
		unset dependency;
	end
	
	unset dependency dependencies;
#check_dependencies:


if_sourced:
	set label_current="if_sourced";
	if( "${label_current}" != "${label_previous}" ) \
		goto label_stack_set;
	
	if(! ${?being_sourced} ) \
		goto main;
	
	if(! ${?supports_being_source} ) \
		goto sourcing_disabled;
	
	goto sourcing_init;
#if_sourced:


sourcing_disabled:
	set label_current="sourcing_disabled";
	if( "${label_current}" != "${label_previous}" ) \
		goto label_stack_set;
	
	# BEGIN: disable source script_basename.  For exception handeling when this file is 'sourced'.
	@ errno=-502;
	goto exception_handler;
	# END: disable source script_basename.
#sourcing_disabled:


sourcing_init:
	set label_current="sourcing_init";
	if( "${label_current}" != "${label_previous}" ) \
		goto label_stack_set;
	
	# BEGIN: source script_basename support.
	source "${TCSH_RC_SESSION_PATH}/argv:check" "${script_basename}" ${argv};
#sourcing_init:


sourcing_main:
	set label_current="sourcing_main";
	if( "${label_current}" != "${label_previous}" ) \
		goto label_stack_set;
	
	# START: special handler for when this file is sourced.
	alias ${script_alias} \$"{TCSH_LAUNCHER_PATH}/${script_basename}";
	# FINISH: special handler for when this file is sourced.
#sourcing_main:


sourcing_main_quit:
	set label_current="sourcing_main_quit";
	if( "${label_current}" != "${label_previous}" ) \
		goto label_stack_set;
	
	source "${TCSH_RC_SESSION_PATH}/argv:clean-up" "${script_basename}";
	
	# END: source script_basename support.
	
	goto script_main_quit;
#sourcing_main_quit:


main:
	set label_current="main";
	if( "${label_current}" != "${label_previous}" ) \
		goto label_stack_set;
#main:


exec:
	set label_current="exec";
	if( "${label_current}" != "${label_previous}" ) \
		goto label_stack_set;
	
	if(! ${?playlist} ) then
		@ errno=-506;
		goto exception_handler;
	endif
	
	if(! -e "${playlist}" ) then
		@ errno=-506;
		goto exception_handler;
	endif
	
	if( ${?edit_playlist} && ! ${?playlist_edited} ) then
		set playlist_edited;
		${EDITOR} "${playlist}";
	endif
	
	if(! ${?playlist_type} ) then
		set callback="setup_playlist";
		goto callback_handler;
	endif
	
	if( ${?debug} ) \
		printf "Executing %s's main.\n" "${script_basename}";
	
	if( ${?filename_list} ) then
		if( ${?filename} ) then
			if( -e "${filename}.${extension}" ) then
				if( ${?clean_up} ) then
					if(! -e "${playlist}.new" ) then
						printf "${filename}.${extension}" >! "${playlist}.new";
					else
						printf "\n${filename}.${extension}" >> "${playlist}.new";
					endif
				endif
			else
				if(! ${?dead_file_count} ) then
					@ dead_file_count=1;
				else
					@ dead_file_count++;
				endif
				printf "${filename}.${extension}\n";
			endif
		endif
		set callback="process_filename_list";
		goto callback_handler;
	endif
	goto script_main_quit;
#exec:

process_filename_list:
	foreach filename("`cat '${filename_list}' | sed -r 's/^\ //' | sed -r 's/(["\""])/"\""\\"\"""\""/g' | sed -r 's/(["\$"])/"\""\\"\$""\""/g' | sed -r 's/(['\!'])/\\\1/g' | sed -r 's/(\[)/\\\1/g' | sed -r 's/([*])/\\\1/g'`")
		ex '+1d' '+wq!' "${filename_list}";
		set extension="`printf "\""${filename}"\"" | sed -r 's/^(.*)\.([^\.]+)"\$"/\2/g'`";
		set original_extension="${extension}";
		set filename="`printf "\""${filename}"\"" | sed -r 's/^(.*)\.([^\.]+)"\$"/\1/g' | sed -r 's/^\ //' | sed -r 's/(["\""])/"\""\\"\"""\""/g' | sed -r 's/(["\$"])/"\""\\"\$""\""/g' | sed -r 's/(['\!'])/\\\1/g' | sed -r 's/(\[)/\\\1/g' | sed -r 's/([*])/\\\1/g'`";
		set filename="`printf "\""${filename}"\"" | sed -r 's/\\\[/\[/g' | sed -r 's/\\([*])/\1/g'`";
		goto exec;
	end
	rm "${filename_list}";
	unset filename filename_list;
#process_filename_list:

#format_new_playlist:
	if(! ${?clean_up} ) then
		set callback="script_main_quit";
		goto callback_handler;
	endif
	
	if(! -e "${playlist}.new" ) then
		set callback="script_main_quit";
		goto callback_handler;
	endif
	
	if(! ${dead_file_count} ) then
		rm "${playlist}.new";
		set callback="script_main_quit";
		goto callback_handler;
	endif
	
	switch("${playlist_type}")
		case "tox":
			ex '+1,$s/\v^(.*)\/([^\/]+)\.([^\.]+)$/entry\ \{\r\tidentifier\ \=\ \2;\r\tmrl\ \=\ \1\/\2\.\3;\r\tav_offset\ \=\ 3600;\r};\r/' '+wq!' "${playlist}.new";
			printf "#toxine playlist\n\n" >! "${playlist}.swp";
			cat "${playlist}.new" >> "${playlist}.swp";
			printf "#END" >> "${playlist}.swp";
			rm "${playlist}.new";
			mv "${playlist}.swp" "${playlist}.new";
			breaksw;
		
		case "pls":
			set lines=`wc -l "${playlist}.new"`;
			@ line=0;
			@ line_number=0;
			while( $line < $lines )
				@ line++;
				@ line_number++;
				ex "+${line_number}s/\v^(.*)\/([^\/]+)\.([^\.]+)"\$"/File${line}\=\1\/\2\.\3\rTitle${line}\=\2/" '+wq!' "${playlist}.new";
				@ line_number++;
			end
			printf "[playlist]\nnumberofentries=${lines}\n" > "${playlist}.swp";
			cat "${playlist}.new" >> "${playlist}.swp";
			printf "\nVersion=2" >> "${playlist}.swp";
			rm "${playlist}.new";
			mv "${playlist}.swp" "${playlist}.new";
			breaksw;
		
		case "m3u":
		default:
			ex '+1,$s/\v^(.*)\/([^\/]+)\.([^\.]+)$/\#EXTINF:,\2\r\1\/\2\.\3/' '+wq!' "${playlist}.new";
			ex '+1,$s/\v^(\#EXTINF\:,.*)(,\ released\ on.*)$/\1/' '+wq!' "${playlist}.new";
			printf "#EXTM3U\n" >! "${playlist}.swp";
			cat "${playlist}.new" >> "${playlist}.swp";
			rm "${playlist}.new";
			mv "${playlist}.swp" "${playlist}.new";
			breaksw;
	endsw
	mv ${clean_up} "${playlist}.new" "${playlist}";
#format_new_playlist:

script_main_quit:
	set label_current="script_main_quit";
	if( "${label_current}" != "${label_previous}" ) \
		goto label_stack_set;
	
	if( ${?label_current} ) \
		unset label_current;
	if( ${?label_previous} ) \
		unset label_previous;
	if( ${?labels_previous} ) \
		unset labels_previous;
	if( ${?label_next} ) \
		unset label_next;
	
	if( ${?argc} ) \
		unset argc;
	if( ${?argz} ) \
		unset argz;
	if( ${?parsed_arg} ) \
		unset parsed_arg;
	if( ${?parsed_argv} ) \
		unset parsed_argv;
	if( ${?parsed_argc} ) \
		unset parsed_argc;
	
	if( ${?init_completed} ) \
		unset init_completed;
	
	if( ${?being_sourced} ) \
		unset being_sourced;
	if( ${?supports_being_source} ) \
		unset supports_being_source;
	
	if( ${?script} ) \
		unset script;
	if( ${?script_alias} ) \
		unset script_alias;
	if( ${?script_basename} ) \
		unset script_basename;
	if( ${?script_dirname} ) \
		unset script_dirname;
	
	if( ${?dependency} ) \
		unset dependency;
	if( ${?dependencies} ) \
		unset dependencies;
	if( ${?missing_dependency} ) \
		unset missing_dependency;
	
	if( ${?usage_displayed} ) \
		unset usage_displayed;
	if( ${?no_exit_on_usage} ) \
		unset no_exit_on_usage;
	if( ${?display_usage_on_error} ) \
		unset display_usage_on_error;
	if( ${?last_exception_handled} ) \
		unset last_exception_handled;
	
	if( ${?label_previous} ) \
		unset label_previous;
	if( ${?label_next} ) \
		unset label_next;
	
	if( ${?callback} ) \
		unset callback;
	if( ${?last_callback} ) \
		unset last_callback;
	if( ${?callback_stack} ) \
		unset callback_stack;
	
	if( ${?argc_required} ) \
		unset argc_required;
	if( ${?arg_shifted} ) 					\
		unset arg_shifted;
	
	if( ${?escaped_cwd} ) \
		unset escaped_cwd;
	if( ${?escaped_home_dir} ) \
		unset escaped_home_dir;
	if( ${?escaped_starting_dir} ) \
		unset escaped_starting_dir;
	
	if( ${?old_owd} ) \
		unset old_owd;
	
	if( ${?starting_cwd} ) then
		if( "${starting_cwd}" != "${cwd}" ) \
			cd "${starting_cwd}";
	endif
	
	if( ${?original_owd} ) then
		set owd="${original_owd}";
		unset original_owd;
	endif
	
	if( ${?oldcwdcmd} ) then
		alias cwdcmd "${oldcwdcmd}";
		unset oldcwdcmd;
	endif
	
	if( ${?script_supported_extensions} ) \
		unset script_supported_extensions;
	if( ${?filename_list} ) then
		if( ${?filename} ) \
			unset filename;
		if( ${?extension} ) \
			unset extension;
		if( ${?original_extension} ) \
			unset original_extension;
		
		if( -e "${filename_list}" ) \
			rm "${filename_list}";
		unset filename_list;
	endif
	
	if( ${?debug} ) \
		unset debug;
	if( ${?script_diagnosis_log} ) \
		unset script_diagnosis_log;
	
	if( ${?strict} ) \
		unset strict;
	
	if(! ${?errno} ) then
		set status=0;
	else
		set status=$errno;
		unset errno;
	endif
	exit ${status}
#script_main_quit:


usage:
	set label_current="usage";
	if( "${label_next}" != "${label_current}" ) \
		goto label_stack_set;
	
	if( ${?errno} ) then
		if( ${errno} != 0 ) then
			if(! ${?last_exception_handled} ) \
				set last_exception_handled=0;
			if( ${last_exception_handled} != ${errno} ) then
				if(! ${?callback} ) \
					set callback="usage";
				goto exception_handler;
			endif
		endif
	endif
	
	if(! ${?script} ) then
		printf "Usage:\n\t%s [options]\n\tPossible options are:\n\t\t[-h|--help]\tDisplays this screen.\n" "${script_basename}";
	else if( "${program}" != "${script}" ) then
		${program} --help;
	endif
	
	if(! ${?usage_displayed} ) \
		set usage_displayed;
	
	if(! ${?no_exit_on_usage} ) \
		goto script_main_quit;
	
	if(! ${?callback} ) \
		set callback="parse_arg";
	goto callback_handler;
#usage:


exception_handler:
	set label_current="exception_handler";
	if( "${label_next}" != "${label_current}" ) \
		goto label_stack_set;
	
	if(! ${?errno} ) \
		@ errno=-599;
	printf "\n**%s error("\$"errno:%d):**\n\t" "${script_basename}" $errno;
	switch( $errno )
		case -500:
			printf "Debug mode has triggered an exception for diagnosis.  Please see any output above.\n" "${script_basename}" > /dev/stderr;
			@ errno=0;
			breaksw;
		
		case -501:
			printf "One or more required dependencies couldn't be found.\n\t[%s] couldn't be found.\n\t%s requires: %s" "${dependency}" "${script_basename}" "${dependencies}";
			breaksw;
		
		case -502:
			printf "Sourcing is not supported and may only be executed" > /dev/stderr;
			breaksw;
		
		case -503:
			printf "An internal script error has caused an exception.  Please see any output above" > /dev/stderr;
			if(! ${?debug} ) \
				printf " or run: %s%s --debug%s to find where %s failed" '`' "${script_basename}" '`' "${script_basename}" > /dev/stderr;
			printf ".\n" > /dev/stderr;
			breaksw;
		
		case -504:
			printf "One or more required options have not been provided." > /dev/stderr;
			breaksw;
		
		case -505:
			printf "%s%s is an unsupported option.\n\tPlease see: %s%s --help%s for supported options and details" "${dashes}" "${option}" '`' "${script_basename}" '`' > /dev/stderr;
			breaksw;
		
		case -506:
			printf "A valid and existing play list must be specified.\n\tPlease see: %s%s --help%s for supported options and details" '`' "${script_basename}" '`' > /dev/stderr;
			breaksw;
		
		case -599:
		default:
			printf "An unknown error "\$"errno: %s has occured" "${errno}" > /dev/stderr;
			breaksw;
	endsw
	set last_exception_handled=$errno;
	printf "\nrun: %s%s --help%s for more information\n" '`' "${script_basename}" '`' > /dev/stderr;
	
	if( ${?display_usage_on_error} ) \
		goto usage;
	
	if( ${?callback} ) \
		goto callback_handler;
	
	goto script_main_quit;
#exception_handler:

parse_argv:
	set label_current="parse_argv";
	if( "${label_current}" != "${label_previous}" ) \
		goto label_stack_set;
	
	if( ${?init_completed} ) then
		if(! ${?being_sourced} ) then
			set callback="exec";
		else
			set callback="sourcing_main";
		endif
		goto callback_handler;
	endif
	
	@ argc=${#argv};
	@ required_options=0;
	
	if( ${argc} < ${required_options} ) then
		@ errno=-504;
		set callback="parse_argv_quit";
		goto exception_handler;
	endif
	
	@ arg=0;
	while( $arg < $argc )
		@ arg++;
		switch("$argv[$arg]")
			case "--diagnosis":
			case "--diagnostic-mode":
				printf "**%s debug:**, via "\$"argv[%d], diagnostic mode\t[enabled].\n\n" "${script_basename}" $arg;
				set diagnostic_mode;
				if(! ${?debug} ) \
					set debug;
				break;
			
			case "--debug":
				printf "**%s debug:**, via "\$"argv[%d], debug mode\t[enabled].\n\n" "${script_basename}" $arg;
				set debug;
				break;
			
			default:
				continue;
		endsw
	end
	
	if( ${?debug} ) \
		printf "**%s debug:** checking argv.  %d total arguments.\n\n" "${script_basename}" "${argc}";
	
	@ arg=0;
	@ parsed_argc=0;
	unset strict;
#parse_argv:

parse_arg:
	set label_current="parse_arg";
	if( "${label_current}" != "${label_previous}" ) \
		goto label_stack_set;
	
	while( $arg < $argc )
		if(! ${?arg_shifted} ) \
			@ arg++;
		
		if( ${?debug} ) \
			printf "**%s debug:** Checking argv #%d (%s).\n" "${script_basename}" "${arg}" "$argv[$arg]";
		
		if( -e "$argv[$arg]" ) then
			set playlist="$argv[$arg]";
			continue;
		endif
		
		set dashes="`printf "\""%s"\"" "\""$argv[$arg]"\"" | sed -r 's/^\ //' | sed -r 's/(["\""])/"\""\\"\"""\""/g' | sed -r 's/(["\$"])/"\""\\"\$""\""/g' | sed -r 's/(['\!'])/\\\1/g' | sed -r 's/(\[)/\\\1/g' | sed -r 's/([*])/\\\1/g' | sed -r 's/^([\-]{1,2})([^\=]+)(\=?)(['\''"\""]?)(.*)(['\''"\""]?)"\$"/\1/'`";
		if( "${dashes}" == "$argv[$arg]" ) \
			set dashes="";
		
		set option="`printf "\""%s"\"" "\""$argv[$arg]"\"" | sed -r 's/^\ //' | sed -r 's/(["\""])/"\""\\"\"""\""/g' | sed -r 's/(["\$"])/"\""\\"\$""\""/g' | sed -r 's/(['\!'])/\\\1/g' | sed -r 's/(\[)/\\\1/g' | sed -r 's/([*])/\\\1/g' | sed -r 's/^([\-]{1,2})([^\=]+)(\=?)(['\''"\""]?)(.*)(['\''"\""]?)"\$"/\2/'`";
		if( "${option}" == "$argv[$arg]" ) \
			set option="";
		
		set equals="`printf "\""%s"\"" "\""$argv[$arg]"\"" | sed -r 's/^\ //' | sed -r 's/(["\""])/"\""\\"\"""\""/g' | sed -r 's/(["\$"])/"\""\\"\$""\""/g' | sed -r 's/(['\!'])/\\\1/g' | sed -r 's/(\[)/\\\1/g' | sed -r 's/([*])/\\\1/g' | sed -r 's/^([\-]{1,2})([^\=]+)(\=?)(['\''"\""]?)(.*)(['\''"\""]?)"\$"/\3/'`";
		if( "${equals}" == "" ) \
			set equals="";
		
		set quotes="`printf "\""%s"\"" "\""$argv[$arg]"\"" | sed -r 's/^\ //' | sed -r 's/(["\""])/"\""\\"\"""\""/g' | sed -r 's/(["\$"])/"\""\\"\$""\""/g' | sed -r 's/(['\!'])/\\\1/g' | sed -r 's/(\[)/\\\1/g' | sed -r 's/([*])/\\\1/g' | sed -r 's/^([\-]{1,2})([^\=]+)(\=?)(['\''"\""]?)(.*)(['\''"\""]?)"\$"/\4/'`";
		if( "${quotes}" == "" ) \
			set quotes="";
		
		#set equals="";
		set value="`printf "\""%s"\"" "\""$argv[$arg]"\"" | sed -r 's/^\ //' | sed -r 's/(["\""])/"\""\\"\"""\""/g' | sed -r 's/(["\$"])/"\""\\"\$""\""/g' | sed -r 's/(['\!'])/\\\1/g' | sed -r 's/(\[)/\\\1/g' | sed -r 's/([*])/\\\1/g' | sed -r 's/^([\-]{1,2})([^\=]+)(\=?)(['\''"\""]?)(.*)(['\''"\""]?)"\$"/\5/'`";
		#if( "${value}" != "" && "${value}" != "$argv[$arg]" ) then
		#	set equals="=";
		#else if( "${option}" != "" ) then
		if( "${option}" != "$argv[$arg]" && "${equals}" == "" && ( "${value}" == "" || "${value}" == "$argv[$arg]" ) ) then
			@ arg++;
			if( ${arg} > ${argc} ) then
				@ arg--;
			else if( -e "$argv[$arg]" ) then
				@ arg--;
			else
			
				if( ${?debug} ) \
					printf "**%s debug:** Looking for replacement value.  Checking argv #%d (%s).\n" "${script_basename}" "${arg}" "$argv[$arg]";
				
				set test_dashes="`printf "\""%s"\"" "\""$argv[$arg]"\"" | sed -r 's/^\ //' | sed -r 's/(["\""])/"\""\\"\"""\""/g' | sed -r 's/["\$"]/"\""\\"\$""\""/g' | sed -r 's/(['\!'])/\\\1/g' | sed -r 's/(\[)/\\\1/g' | sed -r 's/([*])/\\\1/g' | sed -r 's/^([\-]{1,2})([^\=]+)(=?)['\''"\""]?(.*)['\''"\""]?"\$"/\1/'`";
				set test_option="`printf "\""%s"\"" "\""$argv[$arg]"\"" | sed -r 's/^\ //' | sed -r 's/(["\""])/"\""\\"\"""\""/g' | sed -r 's/(["\$"])/"\""\\"\$""\""/g' | sed -r 's/(['\!'])/\\\1/g' | sed -r 's/(\[)/\\\1/g' | sed -r 's/([*])/\\\1/g' | sed -r 's/^([\-]{1,2})([^\=]+)(\=?)(['\''"\""]?)(.*)(['\''"\""]?)"\$"/\2/'`";
				set test_equals="`printf "\""%s"\"" "\""$argv[$arg]"\"" | sed -r 's/^\ //' | sed -r 's/(["\""])/"\""\\"\"""\""/g' | sed -r 's/(["\$"])/"\""\\"\$""\""/g' | sed -r 's/(['\!'])/\\\1/g' | sed -r 's/(\[)/\\\1/g' | sed -r 's/([*])/\\\1/g' | sed -r 's/^([\-]{1,2})([^\=]+)(\=?)(['\''"\""]?)(.*)(['\''"\""]?)"\$"/\3/'`";
				set test_quotes="`printf "\""%s"\"" "\""$argv[$arg]"\"" | sed -r 's/^\ //' | sed -r 's/(["\""])/"\""\\"\"""\""/g' | sed -r 's/(["\$"])/"\""\\"\$""\""/g' | sed -r 's/(['\!'])/\\\1/g' | sed -r 's/(\[)/\\\1/g' | sed -r 's/([*])/\\\1/g' | sed -r 's/^([\-]{1,2})([^\=]+)(\=?)(['\''"\""]?)(.*)(['\''"\""]?)"\$"/\4/'`";
				set test_value="`printf "\""%s"\"" "\""$argv[$arg]"\"" | sed -r 's/^\ //' | sed -r 's/(["\""])/"\""\\"\"""\""/g' | sed -r 's/(["\$"])/"\""\\"\$""\""/g' | sed -r 's/(['\!'])/\\\1/g' | sed -r 's/(\[)/\\\1/g' | sed -r 's/([*])/\\\1/g' | sed -r 's/^([\-]{1,2})([^\=]+)(\=?)(['\''"\""]?)(.*)(['\''"\""]?)"\$"/\5/'`";
				
				if( ${?debug} ) \
					printf "\tparsed %sargv[%d] (%s) to test for replacement value.\n\tparsed %stest_dashes: [%s]; %stest_option: [%s]; %stest_equals: [%s]; %stest_quotes: [%s]; %stest_value: [%s]\n" \$ "${arg}" "$argv[$arg]" \$ "${test_dashes}" \$ "${test_option}" \$ "${test_equals}" \$ "${test_quotes}" \$ "${test_value}";
				
				if(!("${test_dashes}" == "$argv[$arg]" && "${test_option}" == "$argv[$arg]" && "${test_equals}" == "$argv[$arg]" && "${test_value}" == "$argv[$arg]")) then
					@ arg--;
				else
					set equals="=";
					set value="`printf "\""$argv[$arg]"\"" | sed -r 's/(["\""])/"\""\\"\"""\""/g' | sed -r 's/(["\$"])/"\""\\"\$""\""/g' | sed -r 's/(['\!'])/\\\1/g' | sed -r 's/(\[)/\\\1/g' | sed -r 's/([*])/\\\1/g'`";
					set arg_shifted;
				endif
				unset test_dashes test_option test_equals test_value;
			endif
		endif
		
		#if( "`printf "\""${value}"\"" | sed -r "\""s/^(~)(.*)/\1/"\""`" == "~" ) then
		#	set value="`printf "\""${value}"\"" | sed -r "\""s/^(~)(.*)/${escaped_home_dir}\2/"\"" | sed -r 's/^\ //' | sed -r 's/(["\""])/"\""\\"\"""\""/g' | sed -r 's/['"\$"']/"\""\\'"\$"'"\""/g' | sed -r 's/(['\!'])/\\\1/g' | sed -r 's/(\[)/\\\1/g' | sed -r 's/([*])/\\\1/g'`";
		#endif
		
		#if( "`printf "\""${value}"\"" | sed -r "\""s/^(\.)(.*)/\1/"\""`" == "." ) then
		#	set value="`printf "\""${value}"\"" | sed -r "\""s/^(\.)(.*)/${escaped_starting_dir}\2/"\"" | sed -r 's/^\ //' | sed -r 's/(["\""])/"\""\\"\"""\""/g' | sed -r 's/['"\$"']/"\""\\'"\$"'"\""/g' | sed -r 's/(['\!'])/\\\1/g' | sed -r 's/(\[)/\\\1/g' | sed -r 's/([*])/\\\1/g'`";
		#endif
		
		#if( "`printf "\""${value}"\"" | sed -r "\""s/^(.*)(\*)/\2/"\""`" == "*" ) then
		#	set dir="`printf "\""${value}"\"" | sed -r "\""s/^(.*)\*'"\$"'/\2/"\""`";
		#	set value="`/bin/ls --width=1 "\""${dir}"\""*`";
		#endif
		
		@ parsed_argc++;
		set parsed_arg="${dashes}${option}${equals}${value}";
		if(! ${?parsed_argv} ) then
			set parsed_argv="${parsed_arg}";
		else
			set parsed_argv="${parsed_argv} ${parsed_arg}";
		endif
		
		if( ${?debug} ) \
			printf "\tparsed option %sparsed_argv[%d]: %s\n" \$ "$parsed_argc" "${parsed_arg}";
		
		switch("${option}")
			case "numbered_option":
				if(! ( "${value}" != "" && ${value} > 0 )) then
					printf "%s%s must be followed by a valid number greater than zero." "${dashes}" "${option}";
					breaksw;
				endif
			
				set numbered_option="${value}";
				breaksw;
			
			case "edit-playlist":
				if(! ${?edit_playlist} ) \
					set edit_playlist;
				breaksw;
			
			case "h":
			case "help":
				goto usage;
				breaksw;
			
			case "verbose":
				if(! ${?be_verbose} ) \
					set be_verbose;
				breaksw;
			
			case "playlist":
				if(! -e "${value}" ) then
					@ errno=-506;
					set callback="parse_arg";
					goto exception_handler;
					breaksw;
				endif
				set playlist="${value}";
				breaksw;
			
			case "debug":
				if(! ${?debug} ) \
					set debug;
				breaksw;
			
			case "diagnosis":
			case "diagnostic-mode":
				if( ${?diagnostic_mode} ) \
					breaksw;
				
				printf "**%s debug:**, via "\$"argv[%d], diagnostic mode\t[enabled].\n\n" "${script_basename}" $arg;
				set diagnostic_mode;
				if(! ${?debug} ) \
					set debug;
				breaksw;
			
			case "clean-up":
				switch("${value}")
					case "iv":
					case "verbose":
					case "interactive":
						set clean_up="${dashes}${value}";
						breaksw;
					
					default:
						set clean_up;
						breaksw;
				endsw
				
				if( ${?debug} ) \
					printf "**%s debug:**, via "\$"argv[%d], %s:\t[enabled].\n\n" "${script_basename}" $arg "${option}";
				breaksw;
			
			case "enable":
				switch("${value}")
					case "clean-up":
						if( ${?clean_up} ) \
							breaksw;
						
						if( ${?debug} ) \
							printf "**%s debug:**, via "\$"argv[%d], clean-up mode:\t[%sed].\n\n" "${script_basename}" $arg "${option}";
						set clean_up;
						breaksw;
					
					case "verbose":
						if(! ${?be_verbose} ) \
							breaksw;
						
						printf "**%s debug:**, via "\$"argv[%d], verbose output\t[%sd].\n\n" "${script_basename}" $arg "${option}";
						set be_verbose;
						breaksw;
					
					case "debug":
						if( ${?debug} ) \
							breaksw;
						
						printf "**%s debug:**, via "\$"argv[%d], debug mode\t[%sd].\n\n" "${script_basename}" $arg "${option}";
						set debug;
						breaksw;
					
					case "diagnosis":
					case "diagnostic-mode":
						if( ${?diagnostic_mode} ) \
							breaksw;
						
				
						printf "**%s debug:**, via "\$"argv[%d], diagnostic mode\t[%sd].\n\n" "${script_basename}" $arg "${option}";
						set diagnostic_mode;
						if(! ${?debug} ) \
							set debug;
						breaksw;
					
					default:
						printf "enabling %s is not supported by %s.  See %s --help\n" "${value}" "${script_basename}" "${script_basename}";
						breaksw;
				endsw
				breaksw;
			
			case "disable":
				switch("${value}")
					case "clean-up":
						if(! ${?clean_up} ) \
							breaksw;
						
						if( ${?debug} ) \
							printf "**%s debug:**, via "\$"argv[%d], clean-up mode:\t[%sd].\n\n" "${script_basename}" $arg "${option}";
						unset clean_up;
						breaksw;
					
					case "verbose":
						if(! ${?be_verbose} ) \
							breaksw;
						
						printf "**%s debug:**, via "\$"argv[%d], verbose output\t[%sd].\n\n" "${script_basename}" $arg "${option}";
						unset be_verbose;
						breaksw;
					
					case "debug":
						if(! ${?debug} ) \
							breaksw;
						
						printf "**%s debug:**, via "\$"argv[%d], debug mode\t[%sd].\n\n" "${script_basename}" $arg "${option}";
						unset debug;
						breaksw;
					
					case "diagnosis":
					case "diagnostic-mode":
						if(! ${?diagnostic_mode} ) \
							breaksw;
						
						printf "**%s debug:**, via "\$"argv[%d], diagnostic mode\t[%sd].\n\n" "${script_basename}" $arg "${option}";
						unset diagnostic_mode;
						breaksw;
					
					default:
						printf "disabling %s is not supported by %s.  See %s --help\n" "${value}" "${script_basename}" "${script_basename}";
						breaksw;
				endsw
				breaksw;
			
			default:
				if(! ${?strict} ) \
					breaksw;
				
				if(! ${?argz} ) then
					@ errno=-505;
					set callback="parse_arg";
					goto exception_handler;
					breaksw;
				endif
				
				if( "${argz}" == "" ) then
					set argz="$parsed_arg";
				else
					set argz="${argz} $parsed_arg";
				endif
				breaksw;
		endsw
		
		if( ${?arg_shifted} ) then
			unset arg_shifted;
			@ arg--;
		endif
		
		unset dashes option equals value parsed_arg;
	end
#parse_arg:


parse_argv_quit:
	set label_current="parse_argv_quit";
	if( "${label_current}" != "${label_previous}" ) \
		goto label_stack_set;
	
	if(! ${?callback} ) then
		unset arg argc;
	else
		if( "${callback}" != "parse_arg" ) then
			unset arg;
		endif
	endif
	if( ${?diagnostic_mode} ) then
		set callback="diagnostic_mode";
	else
		if(! ${?callback} ) then
			if(! ${?init_completed} ) then
				set callback="init_complete";
			else if(! ${?being_sourced} ) then
				set callback="exec";
			else
				set callback="sourcing_main";
			endif
		endif
	endif
	
	goto callback_handler;
#parse_argv_quit:


label_stack_set:
	if( ${?current_cwd} ) then
		if( ${current_cwd} != ${cwd} ) \
			cd ${current_cwd};
		unset current_cwd;
	endif
	
	if( ${?old_owd} ) then
		if( ${old_owd} != ${owd} ) then
			set owd=${old_owd};
		endif
	endif
	
	set old_owd="${owd}";
	set current_cwd="${cwd}";
	set escaped_cwd="`printf "\""%s"\"" "\""${cwd}"\"" | sed -r 's/\//\\\//g' | sed -r 's/(["\""])/"\""\\"\"""\""/g' | sed -r 's/(['\!'])/\\\1/g' | sed -r 's/([*])/\\\1/g' | sed -r 's/([\[])/\\\1/g'`";
	#if(! -d "`printf "\""${escaped_cwd}"\"" | sed -r 's/\\([*])/\1/g' | sed -r 's/\\([\[])/\1/g'`" ) then
	#	set cwd_files=();
	#else
	#	set cwd_files="`/bin/ls "\""${escaped_cwd}"\""`";
	#endif
	
	set label_next=${label_current};
	
	if(! ${?labels_previous} ) then
		set labels_previous=("${label_current}");
		set label_previous="$labels_previous[${#labels_previous}]";
	else
		if("${label_current}" != "$labels_previous[${#labels_previous}]" ) then
			set labels_previous=($labels_previous "${label_current}");
			set label_previous="$labels_previous[${#labels_previous}]";
		else
			set label_previous="$labels_previous[${#labels_previous}]";
			unset labels_previous[${#labels_previous}];
		endif
	endif
	
	#set label_previous=${label_current};
	
	set callback=${label_previous};
	
	if( ${?debug} ) \
		printf "handling label_current: [%s]; label_previous: [%s].\n" "${label_current}" "${label_previous}" > /dev/stdout;
	
	#unset label_previous;
	#unset label_current;
	
	goto callback_handler;
#label_stack_set:

setup_playlist:
	set label_current="setup_playlist";
	if( "${label_current}" != "${label_previous}" ) \
		goto label_stack_set;
	
	if(! ${?playlist} ) \
		goto parse_arg;
	
	set playlist_type="`printf "\""%s"\"" "\""${playlist}"\"" | sed -r 's/(.*)\.([^\.]+)"\$"/\1/'`";
	if(! ${?filename_list} ) then
		set filename_list="./.filenames.${script_basename}.@`date '+%s'`";
		cp "${playlist}" "${filename_list}";
	endif
	switch("${playlist_type}")
		case "tox":
			ex '+1,$s/\v^[\ \t]*mrl\ \=\ (.*);$/\1/' '+wq!' "${filename_list}";
			breaksw;
		
		case "pls":
			ex '+1,$s/\v^File[0-9]+\=(.*)$/\1/' '+wq!' "${filename_list}";
			breaksw;
		
	endsw
	ex -s '+1,$s/\v^[^\/].*\n//' '+wq!' "${filename_list}";
	set callback="exec";
	goto callback_handler;
#setup_playlist:


callback_handler:
	if(! ${?callback} ) \
		goto script_main_quit;
	
	if(! ${?callback_stack} ) then
		set callback_stack=("${callback}");
		set last_callback="$callback_stack[${#callback_stack}]";
	else
		if("${callback}" != "$callback_stack[${#callback_stack}]" ) then
			set callback_stack=($callback_stack "${callback}");
			set last_callback="$callback_stack[${#callback_stack}]";
		else
			set last_callback="$callback_stack[${#callback_stack}]";
			unset callback_stack[${#callback_stack}];
		endif
		unset callback;
	endif
	if( ${?debug} ) \
		printf "handling callback to [%s].\n" "${last_callback}" > /dev/stdout;
	
	goto $last_callback;
#callback_handler:


diagnostic_mode:
	set label_current="diagnostic_mode";
	if( "${label_current}" != "${label_previous}" ) \
		goto label_stack_set;
	
	if(! -d "${HOME}/tmp" ) then
		set script_diagnosis_log="/tmp/${script_basename}.diagnosis.log";
	else
		set script_diagnosis_log="${HOME}/tmp/${script_basename}.diagnosis.log";
	endif
	if( -e "${script_diagnosis_log}" ) \
		rm -v "${script_diagnosis_log}";
	touch "${script_diagnosis_log}";
	printf "----------------%s debug.log-----------------\n" "${script_basename}" >> "${script_diagnosis_log}";
	printf \$"argv:\n\t%s\n\n" "$argv" >> "${script_diagnosis_log}";
	printf \$"parsed_argv:\n\t%s\n\n" "$parsed_argv" >> "${script_diagnosis_log}";
	printf \$"{0} == [%s]\n" "${0}" >> "${script_diagnosis_log}";
	@ arg=0;
	while( "${1}" != "" )
		@ arg++;
		printf \$"{%d} == [%s]\n" $arg "${1}" >> "${script_diagnosis_log}";
		shift;
	end
	printf "\n\n----------------<%s> environment-----------------\n" "${script_basename}" >> "${script_diagnosis_log}";
	env >> "${script_diagnosis_log}";
	printf "\n\n----------------<%s> variables-----------------\n" "${script_basename}" >> "${script_diagnosis_log}";
	set >> "${script_diagnosis_log}";
	printf "Create %s diagnosis log:\n\t%s\n" "${script_basename}" "${script_diagnosis_log}";
	@ errno=-500;
	if(! ${?being_sourced} ) then
		set callback="script_main_quit";
	else
		set callback="sourcing_main_quit";
	endif
	goto exception_handler;
#diagnostic_mode:

