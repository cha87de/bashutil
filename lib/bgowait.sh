#######################################
# bgowait (Bash Go wait) waits for background
# tasks started with bgo. bgowait terminates either
# when one or all tasks have finished (optionally kills remaining
# tasks).
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
    if (( $# > 0 )); then freq=$1; shift ; else freq=5; fi
    if (( $# > 0 )); then waitforN=$1; shift ; else waitforN=-1; fi
    if (( $# > 0 )); then killTasks=$1; shift ; else killTasks=0; fi

    totalTasks=$(wc -l /tmp/bgo | cut -d' ' -f1)
    finishedTasks=0

    if [[ $waitforN == -1 ]]; then waitforN=$totalTasks; fi

    while true; do
        for pid in $(cat /tmp/bgo) ; do
            echo "checking $pid"
            kill -0 $pid 2> /dev/null ; pidCheck=$?
            if [[ $pidCheck  == 0 ]] ; then
                # task still running
                continue
            else
                # task stopped. remove from list.
                echo "remove $pid"
                sed -i "/$pid/d" /tmp/bgo
                let finishedTasks+=1
                echo "$finishedTasks" ">=" "$waitforN"
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
        for pid in $(cat /tmp/bgo) ; do
            echo "kill $pid"
            kill -1 $pid 2> /dev/null
            sed -i "/$pid/d" /tmp/bgo
        done
    fi

    rm /tmp/bgo
}

if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f bgowait
else
  bgowait "${@}"
  exit $?
fi