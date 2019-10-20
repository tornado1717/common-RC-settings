# .bash_logout

if [[ -n $PS1 ]]; then
	if [[ -n $my_bashrc__bright_color_supported ]]; then
		echo -e "\033[94m-----.bash_logout-----\033[0m"
	else
		echo -e "\033[1;34m-----.bash_logout-----\033[0m"
	fi
fi

	# If you're paranoid:
#rm -f .bash_history
