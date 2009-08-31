#!/bin/tcsh -f
#alias	alias	"/projects/cli/tcshrc/alias.launcher"


complete	alias	'p/1/c/' 'p/2,/c,f/'

setenv	LS_OPTIONS	"--human-readable --color --quoting-style=c --classify  --group-directories-first --format=vertical"

alias	ps	"/bin/ps -A -c -F --forest --heading"
alias	ps-g	"/bin/ps -A -c -F --forest --heading | egrep"

alias	ls	"ls ${LS_OPTIONS}"
alias	ll	"ls -l"
alias	l	"ll"
alias	lc	"ls --width=1 "
alias	la	"ls --all"
alias	lA	"ls --almost-all"
alias	lD	"ls -l --directory"
alias	lDa	"lD --all"
alias	lDA	"lD --almost-all"

alias	df	"df --human-readable"
alias	du	"du --summarize --human-readable"
alias	du-a	"du ./*"

alias	rd	rmdir

alias	rr	"rm -r"
alias	rf	"rr -f"

alias pidof "pidof -x"
complete pidof 'p/*/c/'

#alias	cp	"cp --interactive --no-dereference"
alias cp	"cp --no-dereference"
#alias	mv	"mv --interactive"
unalias	mv

alias	mkdir	"mkdir -p"
alias	md	"mkdir"

alias	nautilus	"nautilus --no-desktop --browser"

alias	hostname	"hostname --fqdn"
alias	wget		"wget --no-check-certificate"
alias	shasum		"shasum --algorithm 512"

alias	screen-saver	"gnome-screensaver-command --activate &"
alias	unzip		"unzip -o -q"
alias	ispell		"aspell -a --sug-mode=normal"

