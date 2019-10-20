#! /bin/bash
# /bin/sh usually works but might have some issues newer versions of Ubuntu (12.04).  See the top of sh-bash_test__launch-daemon-process.sh for more detailed comment.

###############################################################################
# Example Usage:
#	Implicitly involked by "git commit" when the following is git's .gitconfig:
#		[core]
#			editor = HOME= C:/cygwin64/home/Paul/Vim_settings/gvim-easy__cygwin-git-wrapper.sh

###############################################################################


###############################################################################
# Funcs
###############################################################################

###############################################################################
# "Main"
###############################################################################

########################################
# Print command line arguments/parameters and other inputs
########################################

echo "$# param(s):"
for p in "$@"; do
	echo "    \"$p\""
done

echo "HOME: $HOME"
echo "pwd: $(pwd)"

tmp_comment() {
	shopt -s extdebug  #Enable "extended debugging mode" which makes BASH_ARGC and BASH_ARGV work

	echo "==== Command line args:"
	echo "    BASH_ARGC='$BASH_ARGC'"  #Sounds like this var is only defined in "extended debugging mode"  (see "shopt -s extdebug")
	echo "    BASH_ARGV='$BASH_ARGV'"  #Sounds like this var is only defined in "extended debugging mode"  (see "shopt -s extdebug")
	echo "    BASH_ARGV via array loop with double quotes (\"\$BASH_ARGV\")"
	for a in ${BASH_ARGV[*]}; do
		echo "    >   '$a'"
	done

	echo

	echo "===== via cat (with double quotes):"
	lineNum=0
	for line in "$(cat -)"; do
		((lineNum++))
		echo "line $lineNum = '$line'"
	done
}


########################################
# Modify the file path input parameter to convert it from a Cygwin path to a Windows path
########################################

new1stArg=$(echo "$1" | sed 's#^/home/#C:/cygwin64/home/#')
new1stArg=$(echo "$new1stArg" | sed 's#^/cygdrive/\([A-Za-z]\)/#\1:/#')
if [[ $1 != $new1stArg ]]; then
	echo "converted '$1' to '$new1stArg'"
fi
shift  # Remove the origininal 1st arg

#echo "$# param(s):"
#for p in "$@"; do
#	echo "    \"$p\""
#done

echo -e "\x1B[1;34m=====\x1B[0m"

HOME= C:/cygwin64/home/Paul/Vim_settings/runtime/gvim.exe -y "$new1stArg" "$@"

exit 0
