#!/bin/bash

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <hostname> <command>"
    echo "Commands: sync, run, syncrun, kill, install, start, stop"
    exit 1
fi

HOSTNAME=$1
COMMAND=$2

case $COMMAND in
    sync)
        (rm *.o *.out *.tmp || true) > /dev/null 2>&1
        rsync -r -e 'ssh -i ~/.ssh/id_rasp' . myraspberry@$HOSTNAME:~/raspberry
        ;;
    run)
        ssh -i ~/.ssh/id_rasp myraspberry@$HOSTNAME 'cd ~/raspberry; ./run.sh'
        ;;
    sync-run)
        $0 $HOSTNAME sync
        $0 $HOSTNAME run
        ;;
    kill)
        ssh -i ~/.ssh/id_rasp myraspberry@$HOSTNAME 'sudo pkill run.sh; sudo pkill main.out'
        ;;
    install)
        $0 $HOSTNAME sync
        ssh -i ~/.ssh/id_rasp myraspberry@$HOSTNAME 'cd ~/raspberry; ./install.sh'
        ;;
    start)
        ssh -i ~/.ssh/id_rasp myraspberry@$HOSTNAME 'sudo systemctl start musicbox.service'
        ;;
    stop)
        ssh -i ~/.ssh/id_rasp myraspberry@$HOSTNAME 'sudo systemctl stop musicbox.service'
        ;;
    *)
        echo "Invalid command. Use run, install, or other."
        exit 1
        ;;
esac
