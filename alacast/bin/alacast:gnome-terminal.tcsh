#!/bin/tcsh -f

set alacasts_path = `dirname "${0}"`
set alacasts_exec = "${alacasts_path}/alacast.php"
set alacasts_options = "--update=detailed --logging --interactive"


set alacasts_resolution = "";
if ( -e "${HOME}/.alacast/cli.geometry" ) then
	set alacasts_resolution = `cat "${HOME}/.alacast/cli.geometry"`
else if ( -e "${alacasts_path}/../data/alacast.gnome-terminal.geometry" ) then
	set alacasts_resolution = `cat "${alacasts_path}/../data/cli.geometry"`
else
	set alacasts_resolution = "114x40"
endif

/usr/bin/gnome-terminal \
	--geometry="${alacasts_resolution}" \
	--hide-menubar \
	--title="alacast:cli" \
	--working-directory="${alacasts_path}" \
	--command="${alacasts_exec} ${alacasts_options} ${argv}" &