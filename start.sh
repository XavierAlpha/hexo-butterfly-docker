#!/bin/bash
workdir=.
volume=ssh # default volume
username="$USER"

# prepare the deploy_src
docker build -t $username:volume-prepare -f $workdir/Dockerfile.volume_prepare .
docker run --rm -v $volume:/data $username:volume-prepare # load deploy_src to volume
docker rmi $username:volume-prepare

# start to deploy
mount=/var/local/blog/
docker run --rm -it -v $volume:$mount $username:butterfly # deploy 