# ------------------------------------------------------------
# AUTHOR:      Ole Weidner <ole.weidner@codewerft.net>
# DESCRIPTION: An Apache2 /  WordPress container. 
#
# TO_BUILD:    docker build --rm -t="codewerft/wordpress" .
# TO_RUN:      docker run --name=myblog -d codewerft/wordpress
# 
# Other useful flags: --restart=always

FROM ubuntu:14.04
MAINTAINER Ole Weidner <ole.weidner@codewerft.com>

# Update base distribution
# ------------------------------------------------------------

ENV DEBIAN_FRONTEND noninteractive

# Install Apach2
# ------------------------------------------------------------

RUN apt-get update \
 && apt-get install -y wget pwgen php5-fpm php5-mysql php5-ldap nginx-full php5-gd libssh2-php

RUN rm -rf /var/www/
ADD nginx.conf /etc/nginx/nginx.conf 

ADD ./startup.sh /startup.sh
RUN chmod 755 /startup.sh

# Install Supervisor
# ------------------------------------------------------------

RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
RUN rm -r /etc/supervisor/conf.d/
ADD supervisord.conf /etc/supervisor/supervisord.conf

# Exposed volumes
# ------------------------------------------------------------
VOLUME ["/var/www"]

# Exposed ports
# ------------------------------------------------------------
EXPOSE 80

# Startup
# ------------------------------------------------------------
CMD ["/startup.sh"]
