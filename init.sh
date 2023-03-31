#!/bin/bash
# init.sh

# after volume_prepare, volume has deploy_src/source deploy_src/robots.txt, but not .ssh
# .ssh was loaded to container's /root/.ssh when docker build, and it updates and store back to volume when deploying success.
mount=/var/local/blog
cp -r $mount/source /root/blog/

if [ -d "$mount/.ssh" ]; then
cp -r $mount/.ssh /root/
fi

exec "$@"
