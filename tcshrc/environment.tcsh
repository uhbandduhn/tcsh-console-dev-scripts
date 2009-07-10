#!/tcsh/bin -f
#print the expanded, completed, & corrected command line after is entered but before its executed.
#set echo
set addsuffix

setenv eol '$';
#if(!(${?loginsh})) alias "logout" "exit"

setenv		GREP_OPTIONS	"--binary-files=without-match --color --with-filename --line-number"
alias		grep		"grep ${GREP_OPTIONS}"
alias		egrep		"grep ${GREP_OPTIONS} --perl-regexp"

setenv	LS_OPTIONS	"--human-readable --color --quoting-style=c --classify  --group-directories-first --format=vertical"

set correct=cmd
set autoexpand
set autocorrect
set autolist=ambiguous
set color
set colorcat

set dextract
set dunique

set listjobs=long
set notify
#set notify=1s

alias ssshh 'set nobeep'
#set nobeep
set noclobber
#set noglob

set highlight
set histdup=erase
set histfile="/profile.d/history"
set history=3000
set savehist=( $history "merge" )
set histlit

#set printexitvalue

set nostat=( /afs )
set showdots=1
set symlinks=ignore

set killdup=erase

set implicitcd
set rmstar

#set fignore=(.o \~)
set listflags=( "xa" "ls ${LS_OPTIONS}" )
set listlinks
set listmaxrows=23

# special alias which it ran when 'M-h' or 'M-H' is pressed at the command line
# this command is ran with the current buffer command as its only agument.
#alias	helpcommand	"info"
alias	helpcommand	"man"

unset autologout
unset ignoreeof


if(!(${?loginsh})) then
	unalias logout;
	unalias exit;
	alias "logout" "if( -e /etc/csh.logout ) source /etc/csh.logout ; if( -e ~/.logout ) source ~/.logout ; exit";
	if( ! ${?histfile} && -e "${HOME}/.history" ) set histfile="${HOME}/history";
	source -h "${histfile}"
endif

