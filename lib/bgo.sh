#######################################
# bgo (Bash Go) runs functions in parallel
#
# Call syntax: bgo [parameters] arguments
#
#
# Parameters:
#   -g --waitgroup   [OPTIONAL] Name group specified in bgo, to wait on
#                    processes in this group only 
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

    POSITIONAL=()
    while [[ $# -gt 0 ]]; do
      key="$1"
      case $key in
          -g|--waitgroup)
          WAITGROUP="$2"
          shift # past argument
          shift # past value
          ;;
          *)    # unknown option
          POSITIONAL+=("$1") # save it in an array for later
          shift # past argument
          ;;
      esac
    done
    set -- "${POSITIONAL[@]}" # restore positional parameters

    statefile=/tmp/bgo-${WAITGROUP}
    touch $statefile
	  for task in "$@"; do
        $task &
        ret=$?; pid=$!
        if [[ $ret > 0 ]] ; then
          return $ret
        fi
        echo "$pid ${task}" >> $statefile
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