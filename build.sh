#!/bin/bash
workdir=.
username="$USER"
docker build --target butterfly -t $username:butterfly $workdir