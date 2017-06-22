#######################################
# Trim white spaces at beginning and end
# of specified string
#
# Arguments:
#   string         The string to trim
#
# Returns:
#   -
#
# Author: Christopher Hauser <post@c-ha.de>
#######################################

function trim(){
	echo "$1" | sed 's/^[ \t]*//;s/[ \t]*$//'
} 

if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f trim
else
  trim "${@}"
  exit $?
fi