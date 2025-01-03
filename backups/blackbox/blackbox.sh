#!/bin/bash
if [ ! -f .env ]
then
    export $(grep -v '^#' .env | xargs -0)
fi

curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/$HEALTHCHECK_UUID/start

/home/blackbox/.local/bin/blackbox --config ./blackbox.yaml

curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/$HEALTHCHECK_UUID/$?
