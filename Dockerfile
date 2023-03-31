FROM node:latest as base
# install hexo
WORKDIR /root/blog
RUN npm install hexo-cli -g \
    && hexo init \
    && npm i hexo-theme-butterfly \
    && npm install hexo-renderer-pug \
        hexo-renderer-stylus \
        hexo-generator-search \
        hexo-generator-sitemap \
        hexo-renderer-markdown-it \
        hexo-wordcount \
        hexo-deployer-git \
        katex @neilsustc/markdown-it-katex --save\
    && rm -rf _config*.yml source

ARG sourcedir=.
ARG build_dir=build_src
# implement moon_sun transform
COPY ${sourcedir}/${build_dir}/sun_moon.pug node_modules/hexo-theme-butterfly/layout/includes/${build_dir}/
COPY ${sourcedir}/${build_dir}/sun_moon.styl node_modules/hexo-theme-butterfly/source/css/_layout/
RUN echo "\ninclude ./${build_dir}/sun_moon.pug" >> node_modules/hexo-theme-butterfly/layout/includes/head.pug \
    && sed -i "15d;14s/.*/          a.icon-V.hidden(onclick='switchNightMode()', title=_p('rightside.night_mode_title'))\n            svg(width='25', height='25', viewBox='0 0 1024 1024')\n              use#modeicon(xlink:href='#icon-moon')/" \
    node_modules/hexo-theme-butterfly/layout/includes/rightside.pug
COPY ${sourcedir}/${build_dir}/_config*.yml .


FROM base as butterfly
WORKDIR /root
# Copy id_rsa.pub to remote server
RUN apt-get update && apt-get install -y --no-install-recommends ssh \
    && rm -rf /var/cache/apt/* \
    && rm -rf /var/lib/apt/lists/*

# use self host's ssh key for deploy
ARG username=admin
ARG useremail=admin@email.com
RUN git config --global user.email "${useremail}" \
    && git config --global user.name "${username}" \
    && git config --global init.defaultBranch main

ARG sourcedir=.
COPY ${sourcedir}/init.sh .
COPY ${sourcedir}/ssh /root/.ssh/

VOLUME /var/local/blog/
ENTRYPOINT [ "./init.sh" ]
CMD [ "bash", "-c", "cd ./blog && hexo clean && hexo g && cp /var/local/blog/robots.txt ./public && hexo d && cp -r /root/.ssh /var/local/blog/" ]