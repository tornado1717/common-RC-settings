# .bash_profile

# $my_bashrc__session_is_interactive and $my_bashrc__bright_color_supported haven't been defined yet (they're defined in .bashrc)
# This check causes the text below to be suppressed if we do not have a prompt indicating that this probably isn't an interactive session. This is good because the text output can interfere with the sftp protocol and thus prevent me from logging in with sftp.
#	See: http://info.nccs.gov/resources/general/faq#why_does_sftp_exit_with_the_error_most_likely_the_sftp-server_is_not_in_the_path_of_the_user_on_the_server-side
if [[ -n $PS1 ]]; then
	echo -e "\033[1;32m-----.bash_profile-----\033[0m"
fi


# Source the user's local .bashrc file, if it exists
if [ -f ~/.bashrc ] ; then
	. ~/.bashrc
fi


####################
# My additions to this file
####################

if [[ -n $PS1 ]]; then
	if [[ -n $my_bashrc__bright_color_supported ]]; then
		echo -e "\033[94m-----.bash_profile-----\033[0m"
	else
		echo -e "\033[1;34m-----.bash_profile-----\033[0m"
	fi
fi


##########
# Custom stuff goes here
##########

# ...


if [[ -n $PS1 ]]; then
	if [[ -n $my_bashrc__bright_color_supported ]]; then
		echo -e "\033[93m-----.bash_profile-----\033[0m"
	else
		echo -e "\033[1;33m-----.bash_profile-----\033[0m"
	fi
fi

