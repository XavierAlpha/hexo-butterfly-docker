#### Usage

- **build_src** Change butterfly theme config here, docker need rebuilds when files change
  - _config.butterfly.yml  
butterfly theme config
  - _config.yml 
hexo config, butterfly config will overwrite it if has same config value
  - sun_moon.pug sun_moon.styl 
Switch between day and night modes needs (butterfly theme doesn't implement it), DON'T CHANGE OR DELETE!

- **deploy_src** files in here will store to your volume when docker run, so you need to mount your volume to container. default name of volume is "ssh", change it in start.sh if necessary.
  - source 
all your blog resource, docker loads the newest resource into volume every time it runs.
  - robots.txt 
your robots.txt, hexo doesn't generate it. docker loads the newest "robots.txt" into volume every time it runs.

- **ssh** Only need when docker builds. docker build loads it to your container's ".ssh" for deploying through ssh when "hexo deploy", and after deploying, files like "known_hosts" will update when you type "yes" in the beginning of ssh connection. So it will also store the new ".ssh" to your volume if deploying success, and don't have to repeat typing "yes" next time.

- **init.sh** docker run butterfly's ENTRYPOINT.

- **build.sh** docker build butterfly images

- **uninstall.sh** delete docker images of butterfly

- **start.sh** prepare the volume and deploying

Normally
1. First, Prepare your config in "build_src",
2. Second, Prepare your blog resource in "deploy_src" and robots.txt,
3. Then, Copy the ssh files whose id_rsa.pub should also copy to remote server's authorized_keys(use ssh authorized ways).
4. Then, create your volume using docker, named "ssh". Or change the name to volume=your_volume_name in "start.sh".
5. Finally, Run

If the first time:
```
$ cd /your/blog/path
$ ./build.sh # to build butterfly image
$ ./start.sh
```

Not the first time, then you may:
```
$ cd /your/blog/path
$ ./uninstall.sh # if anything in build_src changes, rebuild the image.
$ ./build.sh
```
or, if nothing changes in build_src. directly:
```
$ ./start.sh # deploy to remote server.
```

Generally, you don't have to delete or rebuild the butterfly images if nothing changes in build_src, when new post created with its resource, moving them to deploy_src/source's different positions, then running ./start.sh, new post will be deployed to remote server, and all containers generated when deploying will be clear,next time new post comes, repeat this command is enough.

e.g in ubuntu 22.04.2 LTS, run docker images, you will see images:
```
REPOSITORY  TAG        IMAGE ID        CREATED      SIZE
busybox     latest     xxxxxxxxxxxx    xx ago       4.86MB
node        latest     xxxxxxxxxxxx    xx ago       999MB
xavier      butterfly  xxxxxxxxxxxx    xx ago       1.13GB
```
that will be used kept in the background.