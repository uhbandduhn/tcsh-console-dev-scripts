#!/bin/tcsh -f
set music_path = "/media/library/music";
set music_library = "`basename '${0}' | sed 's/.*organize:\(.*\)\.tcsh/\1/g'`";
set podcasts_download_path = "/media/podcasts";

if( ! -d "${music_path}/${music_library}" ) then
	printf "The music library's path is not a valid directory. so I'm unable to continue.\nI attempted to organize music using the following path:\n\t%s/%s\n" "${music_path}" "${music_library}";
	exit -1;
endif

cd "${music_path}/${music_library}";

# Archiving all new sons, top tracks, or podcasts:
foreach genre ( "`find '${podcasts_download_path}' -type d -name '${music_library}*'`" )
	set genre = "`printf '${genre}' | sed 's/.*\/${music_library}:\?\ genre\ \(.*\).*/\1/g'`";
	printf "Moving %s's new %s songs\n" "${music_library}" "${genre}";
	if( ! -d "Genres/${genre}" ) mkdir -p "Genres/${genre}";
	mv ${podcasts_download_path}/${music_library}*\ genre\ "${genre}"/* "Genres/${genre}/";
	rmdir ${podcasts_download_path}/${music_library}*\ genre\ "${genre}"/;
end

foreach title ( "`find Genres -iregex '.*, released on.*\.\(mp.\|ogg\|flac\)'`" )
	set genre = "`printf "\""${title}"\"" | sed 's/Genres\/\([^\/]\+\)\/\(.*\)\ \-\ \(.*\)\(, released on[^\.]*\)\.\(mp.\|ogg\|flac\)/\1/g'`";
	set song = "`printf "\""${title}"\"" | sed 's/Genres\/\([^\/]\+\)\/\(.*\)\ \-\ \(.*\)\(, released on[^\.]*\)\.\(mp.\|ogg\|flac\)/\3/g'`";
	set artist = "`printf "\""${title}"\"" | sed 's/Genres\/\([^\/]\+\)\/\(.*\)\ \-\ \(.*\)\(, released on[^\.]*\)\.\(mp.\|ogg\|flac\)/\2/g'`";
	set extension = "`printf "\""${title}"\"" | sed 's/.*\.\(mp.\|ogg\|flac\)/\1/g'`";
	mv "${title}" "Genres/${genre}/${artist} - ${song}.${extension}";
end

foreach title ( "`find Genres -iregex '.*\.\(mp.\|ogg\|flac\)'`" )
	set song = "`printf "\""${title}"\"" | sed 's/.*\/\(.*\)\ \-\ \(.*\)\.\(mp.\|ogg\|flac\)/\2/g'`";
	set artist = "`printf "\""${title}"\"" | sed 's/.*\/\(.*\)\ \-\ \(.*\)\.\(mp.\|ogg\|flac\)/\1/g'`";
	set extension = "`printf "\""${title}"\"" | sed 's/.*\.\(mp.\|ogg\|flac\)/\1/g'`";
	
	if( -e "Artists/${artist}/${song}.${extension}" ) continue;
	
	printf "Linking %s to %s/%s/%s.%s\n" "${title}" "Artists" "${artist}" "${song}" "${extension}";
	if( ! -d "Artists/${artist}" ) mkdir -p "Artists/${artist}";
	ln "${title}" "Artists/${artist}/${song}.${extension}";
	if( ! -e "Artists/${artist}/${song}.${extension}" ) printf "\tERROR: I was unable to link %s to Artists/%s/%s.${extension}\n" "${title}" "${artist}" "${song}";
end
