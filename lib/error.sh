#######################################
# Error message printer to stderr
#
# Arguments:
#   message         the error message to print
#
# Returns:
#   -
#
# Author: Christopher Hauser <post@c-ha.de>
#######################################

function error(){
	echo "ERROR: $(date) $1" >&2
}

if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f error
else
  error "${@}"
  exit $?
fi