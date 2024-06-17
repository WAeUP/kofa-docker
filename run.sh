#!/bin/bash
#
# run.sh PID_PATH START_CMD_PART1 [START_CMD_PART2 ...]
#
# Install signal handler to catch SIGTERM, then run START_CMD in background.
# When SIGTERM is sent to this process, we send SIGTERM to the process with the
# PID given in file at PID_PATH.
#
# This way we circumvent the problem, that docker will try to kill the first
# started provess, while we have to kill the process started in background
# first.
#
# (c) 2024 WAeUP Germany https://waeup.org/
# Licensed under AGPL 3.0 or later

PID_PATH=$1
shift

cleanup() {
    echo "Container stopped, perform cleanup"
    PID_NUM=`cat ${PID_PATH}`
    # send SIGTERM to background process
    kill -s TERM `cat ${PID_PATH}`
    echo "Sent SIGTERM to PID $PID_NUM..."
}

echo "installing signal handler"
trap 'cleanup' SIGTERM

echo "run daemon... ${@}"
"${@}" &

wait $!
