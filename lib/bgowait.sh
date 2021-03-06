#######################################
# bgowait (Bash Go wait) waits for background
# tasks started with bgo. bgowait terminates either
# when one or all tasks have finished (optionally kills remaining
# tasks).
#
# Call syntax: bgowait [parameters] arguments
#
# Parameters:
#   -g --waitgroup   [OPTIONAL] Name group specified in bgo, to wait on
#                    processes in this group only 
#
# Arguments:
#   freq             Frequency how often tasks are checked (default 5s)
#   waitforN         Amount of tasks having finished to return (-1 for all tasks)
#   killTasks        When set to 1, tasks running after waitforN
#                    returned will be killed
#
# Returns:
#   -
#
# Author: Christopher Hauser <post@c-ha.de>
#######################################

function bgowait(){

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

    if (( $# > 0 )); then freq=$1; shift ; else freq=5; fi
    if (( $# > 0 )); then waitforN=$1; shift ; else waitforN=-1; fi
    if (( $# > 0 )); then killTasks=$1; shift ; else killTasks=0; fi

    statefile=/tmp/bgo-${WAITGROUP}

    if [[ ! -f $statefile ]]; then return ; fi

    totalTasks=$(wc -l $statefile | cut -d' ' -f1)
    finishedTasks=0

    if [[ $waitforN == -1 ]]; then waitforN=$totalTasks; fi

    while true; do
        for pid in $(cat $statefile | cut -d' ' -f1) ; do
            kill -0 $pid 2> /dev/null ; pidCheck=$?
            if [[ $pidCheck  == 0 ]] ; then
                # task still running
                continue
            else
                # task stopped. remove from list.
                taskline=$(cat $statefile | grep "$pid ")
                echo "task ended: ${taskline}"
                sed -i "/$pid */d" $statefile
                let finishedTasks+=1
                if (( "$finishedTasks" >= "$waitforN" )); then
                    # done with waiting...
                    break 2
                fi
            fi
        done
        if (( "$finishedTasks" < "$waitforN" )); then
            sleep $freq
        fi
    done

    if [[ $killTasks == 1 ]]; then
        # kill remaining and running tasks
        for pid in $(cat $statefile | cut -d' ' -f1) ; do
            echo "killing task $pid ..."
            kill -1 $pid 2> /dev/null
            sed -i "/$pid */d" $statefile
        done
    fi

    rm $statefile
}

if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f bgowait
else
  bgowait "${@}"
  exit $?
fi