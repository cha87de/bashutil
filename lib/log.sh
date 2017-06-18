#######################################
# Log message printer to stdout
#
# Arguments:
#   message         the log message to print
#
# Returns:
#   -
#
# Author: Christopher Hauser <post@c-ha.de>
#######################################

function log(){
	echo "INFO: $(date) $1" >&1
}

if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f log
else
  log "${@}"
  exit $?
fi