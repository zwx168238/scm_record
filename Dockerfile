FROM ubuntu:16.04

ENV http_proxy ${http_proxy:-}
ENV https_proxy ${https_proxy:-}
ENV no_proxy ${no_proxy:-}
ENV USER root

COPY sources.list /etc/apt/sources.list
RUN apt-get -qq update
#RUN apt-get -qqy upgrade

RUN echo "dash dash/sh boolean false" | debconf-set-selections && \
    dpkg-reconfigure -p critical dash

# install all of the tools and libraries that we need.
RUN apt-get update && \
    apt-get install -y bc bison bsdmainutils build-essential curl \
        flex g++-multilib gcc-multilib git gnupg gperf lib32ncurses5-dev \
        lib32readline-gplv2-dev lib32z1-dev libesd0-dev libncurses5-dev \
        libsdl1.2-dev libwxgtk2.8-dev libxml2-utils lzop \
        pngcrush schedtool xsltproc zip zlib1g-dev

# openjdk-8-jdk
RUN apt-get install -y openjdk-8-jdk openjdk-8-jre

# Extras that android-x86.org and android-ia need
RUN apt-get update && apt-get install -y gettext python-libxml2 yasm bc
RUN apt-get update && apt-get install -y squashfs-tools genisoimage dosfstools mtools

# install for bp build
RUN apt-get install -y libxml-parser-perl

# install useful tools
RUN apt-get install -y htop tig vim emacs zip unzip

# install en language for build BP
RUN apt-get install -y language-pack-en-base
ENV LANG en_US.UTF-8

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY repo /usr/local/bin/
RUN chmod 755 /usr/local/bin/*

RUN apt-get update && apt-get install -y software-properties-common python-software-properties

# We need this because of this https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/
# Here is solution https://engineeringblog.yelp.com/2016/01/dumb-init-an-init-for-docker.html
COPY dumb-init /usr/local/bin/
RUN chmod +x /usr/local/bin/dumb-init

COPY build.sh /usr/local/bin/build.sh
RUN chmod 755 /usr/local/bin/build.sh

#fix TAB can't completion
RUN apt-get update && apt-get install -y bash-completion

# add sshd
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
# for 16.04
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# for 14.04
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

VOLUME /home/test
COPY start.sh /start.sh

EXPOSE 22
CMD ["/usr/local/bin/dumb-init", "--", "/start.sh"]
