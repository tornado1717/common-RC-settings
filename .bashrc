# .bashrc

# Set this to something if "bright" colors (90-97,100-107) are supported
#my_bashrc__bright_color_supported="asdf"

if [ `uname -s` == "Darwin" ]; then  # Mac OSs
	my_bashrc__running_on_Mac="true"
		#echo "    my_bashrc__running_on_Mac"  # Printed down below so we don't mess up sftp
elif
	# TODO: update this if ever needed
	[[ `uname -n` == someMachineNamePrefix*-lnx ]] ||
then
	my_bashrc__running_on_Ubuntu="true"
		#echo "    my_bashrc__running_on_Ubuntu"  # Printed down below so we don't mess up sftp
elif
	[[ `uname`    == *CYGWIN* ]] ||  # "CYGWIN_NT-5.1"
		#[ `uname -o` == "Cygwin" ]  # Also works
	[[ `uname`    == *MINGW* ]]  # "MINGW32_NT-6.1"
		#[ `uname -o` == "Msys" ]  # Also works
then
	my_bashrc__running_on_Cygwin="true"
		#echo "    my_bashrc__running_on_Cygwin"  # Printed down below so we don't mess up sftp
fi

if
	[[ -n $my_bashrc__running_on_Mac ]] ||
	[[ -n $my_bashrc__running_on_Ubuntu ]]
then
	my_bashrc__bright_color_supported="asdf"
fi


########################################
# This check causes the text below to be suppressed if we do not have a prompt indicating that this probably isn't an interactive session.
#	This is needed because the text output can interfere with the sftp protocol and thus prevent me from logging in with sftp.
#	The text output also messes with rsync.
#	See: http://info.nccs.gov/resources/general/faq#why_does_sftp_exit_with_the_error_most_likely_the_sftp-server_is_not_in_the_path_of_the_user_on_the_server-side

#	csh/tcsh equivalent:
#	if ($?prompt)
#		echo stuff
#	endif
########################################

if
	[[ -n $PS1 ]]
	#&& [[ "$-" == *i* ]]  # New method for detecting interactive prompts (from Cygwin's default profile)
	#[ -n "${-//[^i]}" ]  # Variation of the Cygwin method
then
	# Set this to something if we have an interactive session (we have a command prompt, this isn't an sftp session)
	my_bashrc__session_is_interactive="true"
	if [[ -n $my_bashrc__bright_color_supported ]]; then
		echo -e "\033[92m-----.bashrc-----\033[0m"
	else
		echo -e "\033[1;32m-----.bashrc-----\033[0m"
	fi

	if [[ -n $my_bashrc__running_on_Mac ]]; then
		echo "    my_bashrc__running_on_Mac"
	elif [[ -n $my_bashrc__running_on_Ubuntu ]]; then
		echo "    my_bashrc__running_on_Ubuntu"
	elif [[ -n $my_bashrc__running_on_Cygwin ]]; then
		echo "    my_bashrc__running_on_Cygwin"
	fi
fi

# Shortcut
# If not running interactively, don't do anything
#[ -z "$PS1" ] && return


########################################

if [[ -n $my_bashrc__session_is_interactive ]]; then
	if [[ -n $my_bashrc__bright_color_supported ]]; then
		echo -e "\033[94m-----.bashrc-----\033[0m"
	else
		echo -e "\033[1;34m-----.bashrc-----\033[0m"
	fi


	####################

	# If $my_bashrc__replacement_home_dir is set, assume that we don't have our own home dir but a makeshift one exists at the location it points to
	if [[ -n $my_bashrc__replacement_home_dir ]]; then
		tmp_HomeDir=$my_bashrc__replacement_home_dir
	else
		#tmp_HomeDir="~"  # Doesn't work for some reason - the '~' isn't getting expanded by the shell
		tmp_HomeDir=$HOME
	fi

	# User specific aliases and functions
	source $tmp_HomeDir/settings/.bashrc__command_aliases

	source $tmp_HomeDir/settings/.bashrc__keybindings
	source $tmp_HomeDir/settings/.bashrc__set_color_prompt
	source $tmp_HomeDir/settings/.bashrc__command_colors

	source $tmp_HomeDir/settings/.bashrc__someMachineOrEnvironmentSpecificConfigs


	########################################
	# other settings
	########################################

	####################
	# history settings
	####################

	if [[ -n $my_bashrc__replacement_home_dir ]]; then
		if [[ -n $my_bashrc__replacement_home_dir__hist_location ]]; then
			export HISTFILE=$my_bashrc__replacement_home_dir__hist_location
			export HISTSIZE=10000
			export HISTFILESIZE=10000
		else
			# We don't have an official home dir so just ignore history
			unset HISTFILE  # Don't write the command history to a file when the session is closed (~/.bash_history)
			echo "No official home directory - not saving command history"
		fi
	else
		export HISTSIZE=10000
		export HISTFILESIZE=10000
	fi

	# Don't store duplicate adjacent items in the history
	export HISTCONTROL=ignoreboth
	#	export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups  # <- ???, from new Cygwin

	# Erases duplicate items in the history
	#	Untested!
	#export HISTCONTROL=erasedups
	#shopt -s histappend  # Untested!  "tells the shell to append to the older history file, not overwrite it on exit"

	# Ignore some controlling instructions   (from Cygwin)
	#	HISTIGNORE is a colon-delimited list of patterns which should be excluded.
	#	The '&' is a special pattern which suppresses duplicate entries.
	#export HISTIGNORE="[   ]*:&:bg:fg:exit"
	#export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
	#export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls'  # Ignore the ls command as well


	####################
	# tab completion (many misc things)
	#	See:
	#		http://stackoverflow.com/questions/3746/whats-in-your-bashrc
	#			http://www.caliban.org/bash/#completion
	#		~/settings/.bashrc__keybindings
	####################

	#source /etc/bash_completion


	####################
	# tab completion (git commands)
	#	See:
	#		http://stackoverflow.com/questions/3746/whats-in-your-bashrc
	#			http://repo.or.cz/w/git.git?a=blob_plain;f=contrib/completion/git-completion.bash;hb=HEAD
	#		~ccooper/git/git-completion.sh
	#		git source code (git://git.kernel.org/pub/scm/git/git.git): <repo>/contrib/completion/git-completion.bash   (as of v2.17.1)
	####################
	if
		[[ `uname`    == *CYGWIN* ]]  # "CYGWIN_NT-5.1"
	then
		source ~/git_src/contrib/completion/git-completion.bash
		PATH=~/git_src:$PATH
		export PERL5LIB="$PERL5LIB:~/git_src/perl/"
		export PERL5LIB="$PERL5LIB:/home/Paul/git_src/perl/"
	elif [[ ! -n $my_bashrc__replacement_home_dir ]]; then
		source ~/settings/git-completion.sh
	fi

	# stops cd from [tab][tab] showing .DS_Store and such files, unless you do .[tab][tab] - this means I can do cat [tab] to select the only file visible file in the directory (instead of always getting .DS_Store and the file)
	#	See:
	#		http://stackoverflow.com/questions/3746/whats-in-your-bashrc
	#bind 'set match-hidden-files off'  # untested


	########################################
	# General Mac stuff
	########################################

	if
		[[ -n $my_bashrc__running_on_Mac ]]
	then
		# Disable "resource fork" awareness in Mac's unix utilities like "mv", "cp", ...
		#	A resouce fork is extra file attribs that most non-Mac filesystems don't use.  Mac handles this by making a file named "._<fileName>" for EVERY file <fileName> you touch on another filesystem
		#	Disabling this should make most of those spam files stop appearing everywhere the Mac touches and every file named ._* that ISN'T a resource fork hopefully won't get clobbered or ignored
		export COPY_EXTENDED_ATTRIBUTES_DISABLE=true  # For Mac OS X 10.4
		export COPYFILE_DISABLE=true  # For Leopard and Snow Leopard
	fi


	########################################
	# General Cygwin stuff
	########################################

#	if
#		[[ -n $my_bashrc__running_on_Cygwin ]]
#	then
#		# TODO: see "nodosfilewarning" to maybe make file paths that look like "c:\blah" and/or "c:/blah" work
#	fi


	########################################
	# General again
	########################################

	# Remove empty items from the path
	# Useful because empty items "::" seems to add "." to the path
	#	Ex - value for $PATH before and after the fix:
	#		"dir1:dir2:::dir3"
	#			->
	#		"dir1:dir2:dir3"
	PATH=`echo $PATH | sed "s/:\+/:/g"`

	# New versions of Perl don't include the current dir (".") in the path - fix that
	# See "taint mode"
	if
		[[ `uname` == *CYGWIN* ]] &&  # "CYGWIN_NT-10.0"
		[[ `perl --version` == *v5.26.1* ]]
	then
		export PERL5LIB="$PERL5LIB:."
	fi
fi

if [[ -n $my_bashrc__session_is_interactive ]]; then  # For some reason, exiting the if block and then re-entering an identical one is required to make the "echo -e" alias to work here
	if [[ -n $my_bashrc__bright_color_supported ]]; then
		echo "\033[93m-----.bashrc-----\033[0m"
	else
		echo "\033[1;33m-----.bashrc-----\033[0m"
	fi
fi
