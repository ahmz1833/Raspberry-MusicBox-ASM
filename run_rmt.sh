#!/bin/bash
rsync -r  -e 'ssh -i ~/.ssh/id_rasp' . myraspberry@$1:~/raspberry
ssh -i ~/.ssh/id_rasp myraspberry@$1 'cd ~/raspberry; ./run.sh'
