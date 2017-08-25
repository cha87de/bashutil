#######################################
# bgo (Bash Go) runs functions in parallel
#
# Arguments:
#   task1         task to execute
#   task2         task to execute
#   ...
#   taskn         task to execute
#
# Returns:
#   -
#
# Author: Christopher Hauser <post@c-ha.de>
#######################################

function bgo(){
    touch /tmp/bgo
	  for task in "$@"; do
        $task &
        ret=$?; pid=$!
        if [[ $ret > 0 ]] ; then
          return $ret
        fi
        echo "$pid ${task}" >> /tmp/bgo
        echo "started ${task} as $pid"
    done
    return 0
}

if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f bgo
else
  bgo "${@}"
  exit $?
fi