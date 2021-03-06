#!/bin/tcsh -f
if(! ${?TCSH_RC_SESSION_PATH} ) \
	setenv TCSH_RC_SESSION_PATH "/projects/cli/console.pallet/tcshrc";
source "${TCSH_RC_SESSION_PATH}/argv:check" "history.cshrc.tcsh" ${argv};
if( $args_handled > 0 ) then
	@ args_shifted=0;
	while( $args_shifted < $args_handled )
		@ args_shifted++;
		shift;
	end
	unset args_shifted;
endif
unset args_handled;

if( ${?histfile} && ${?my_history} ) then
	if( "${histfile}" == "${my_history}" ) then
		goto exit_script;
	endif
endif

set my_history="/profile.d/history";
set highlight;
set histlit;
set histdup=erase;
set histfile="${my_history}";
if( -e "${histfile}.jobs" ) \
	/bin/rm -f "${histfile}.jobs";
if( -e "${histfile}.lock" ) \
	/bin/rm -f "${histfile}.lock";
set history=6000;
set savehist=( $history "merge" );

source "${TCSH_RC_SESSION_PATH}/history.check.cshrc.tcsh" ${argv};

if( ${?loginsh} ) \
	goto exit_script;

unalias logout;
unalias exit;

alias logout 'source "${TCSH_RC_SESSION_PATH}/etc-csh.logout" \
		if( $status == 0 ) exit;';

exit_script:
	source "${TCSH_RC_SESSION_PATH}/argv:clean-up" "history.cshrc.tcsh";
#exit_script:

