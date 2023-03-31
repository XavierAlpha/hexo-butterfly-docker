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

- **ssh** Only need when docker builds. docker build loads it to your container's ".ssh" for deploying through ssh when "hexo deploy", and after deploying, files like "known_hosts" will update when you type "yes" in the beginning of ssh connection. So it will also store the new ".ssh" to your volume if deploying success, and it does have to type "yes" next time.

- **init.sh** docker run butterfly's ENTRYPOINT.

- **build.sh** docker build butterfly images

- **uninstall.sh** delete docker images of butterfly

- **start.sh** prepare the volume and deploying

Normally
1. First, Prepare your config in "build_src",
2. Second, Prepare your blog resource in "deploy_src" and robots.txt,
3. Then, Copy the ssh files whose id_rsa.pub should also copy to remote server's authorized_keys.
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
then:
```
$ ./start.sh # after build.sh, start to deploy to remote server.
```