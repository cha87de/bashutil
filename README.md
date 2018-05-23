# bashutil - a bpkg package for utility functions

Writing bash scripts can be very boring, when recurring functions for logging, error messages, string parsing or similar utility tasks are needed. This package offers a set
of utility functions you will need for any bash script you write.

This repository is meant to be a package for the [bpkg bash package manager](http://www.bpkg.sh/).


## Installation

 1. Clone this repository and source the files directly, or
 2. Use the bpkg bash package manager: `bpkg install cha87de/bashutil -g`

To install bpkg, run `curl -sLo- http://get.bpkg.sh | bash`.

## Usage


### bgo & bgowait

The tools bgo and bgowait allow to start a group of processes and wait for them. Example usage:

```
#!/bin/bash
source lib/bgo.sh
source lib/bgowait.sh

function sleeper(){
    sleep 50
    return 0
}
function timer(){
    sleep 1
    date
    return 0
}

# start

bgo sleeper timer

# wait

#freq=5; waitForN=-1; killTasks=0 # fail one, ignore (e.g. development mode)
freq=5; waitForN=1; killTasks=1 #fail one, fail all (e.g. production mode)
bgowait $freq $waitForN $killTasks
```

The option `--waitgroup` allows to run more than one bgo & bgowait pair in parallel, with a different set of processes to wait for. If no wait group is specified, bgowait assumes all processes started with bgo - **system wide**.
Example usage with wait groups:

```
#!/bin/bash
source lib/bgo.sh
source lib/bgowait.sh

function sleeper(){
    sleep 50
    return 0
}
function timer(){
    sleep 1
    date
    return 0
}

# start

bgo -g group1 sleeper timer
bgo -g group2 timer

# wait

freq=5; waitForN=-1; killTasks=0 # fail one, ignore
bgowait -g group1 $freq $waitForN $killTasks

freq=5; waitForN=1; killTasks=1 #fail one, fail all
bgowait -g group2 $freq $waitForN $killTasks
```