FROM registry.skysolutions.fi/library/nginx-fancyindex:28102024@sha256:937bfb6e05e8ec97e9955801f451e1a5969f504f106214807a5bc1dbc91b6204

ENV SET_CONTAINER_TIMEZONE=false
ENV CONTAINER_TIMEZONE=""
ENV DISABLE_AUTH=false

# manage start container
COPY apps/fancyindex/src/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN mkdir /usr/share/docker-entrypoint.pre &&  mkdir /usr/share/docker-entrypoint.post
COPY apps/fancyindex/src/00_init.sh /usr/share/docker-entrypoint.pre/00_init.sh
RUN chmod +x -R /usr/share/docker-entrypoint.pre

# install extra nginx
RUN apk add --no-cache \
        apache2-utils \
        git \
        wget \
        bash

COPY apps/fancyindex/src/nginx/* /etc/nginx/conf.d/
RUN rm /etc/nginx/sites-enabled/default

# add cmd nginx
COPY apps/fancyindex/src/cmd/addauth.sh /usr/bin/addauth
COPY apps/fancyindex/src/cmd/rmauth.sh /usr/bin/rmauth
RUN chmod +x /usr/bin/addauth && chmod +x /usr/bin/rmauth

# add theme
RUN mkdir /theme
WORKDIR /theme
RUN wget https://github.com/alehaa/nginx-fancyindex-flat-theme/releases/download/v1.1/nginx-fancyindex-flat-theme-1.1.tar.gz && tar xvzf nginx-fancyindex-flat-theme-1.1.tar.gz && rm nginx-fancyindex-flat-theme-1.1.tar.gz && rm flat-theme/theme.css
COPY apps/fancyindex/src/theme.css flat-theme/theme.css
#ENV COLOR "blue"

RUN mkdir /share
VOLUME /share

ENV WEBUSER=user
ENV WEBPASSWORD=pass

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
CMD ["app"]
