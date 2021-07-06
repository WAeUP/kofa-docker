FROM ubuntu:20.04

MAINTAINER Uli Fouquet <uli@waeup.org>

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y tzdata
RUN apt-get install -y apt-utils build-essential
RUN apt-get install -y python2.7-dev libxml2-dev libxslt1-dev \
                       zlib1g-dev python3-virtualenv
# see https://urllib3.readthedocs.org/en/latest/security.html#openssl-pyopenssl
RUN apt-get install -y libssl-dev libffi-dev
# libs needed/useful for Pillow image manipulations
RUN apt-get install -y libjpeg-dev libfreetype6-dev libtiff-dev libopenjp2-7-dev
RUN apt-get install -y sudo git wget

# fix link needed by Pillow
RUN ln -s /usr/include/freetype2 /usr/include/freetype2/freetype

# add user `kofa`
RUN useradd -ms /bin/bash kofa
# set password of user `kofa` and add to group 'sudo'
RUN echo kofa:kofa | chpasswd && adduser kofa sudo

# get sources
WORKDIR /home/kofa
RUN wget https://files.pythonhosted.org/packages/8e/9c/d65182d4361c8c47ec50090d97c4b6f013c7c63589b9e0fe239c37fb8f36/waeup.kofa-1.7.1.tar.gz && tar -xzf waeup.kofa-1.7.1.tar.gz
RUN tar -xzf waeup.kofa-1.7.1.tar.gz
RUN mv waeup.kofa-1.7.1 waeup.kofa

# make sure, all added files belong to `kofa`
RUN chown -R kofa:kofa /home/kofa/

USER kofa
ENV HOME /home/kofa

# create a virtual env
RUN virtualenv -p /usr/bin/python2.7 py27

# install kofa -- this is the heavy part...
WORKDIR /home/kofa/waeup.kofa
RUN /home/kofa/py27/bin/pip install --upgrade pip
RUN /home/kofa/py27/bin/pip install zc.buildout
RUN /home/kofa/py27/bin/buildout

# this dir will contain data you might want to be persistent
VOLUME ["/home/kofa/waeup.kofa/var/"]

CMD /home/kofa/waeup.kofa/bin/kofactl fg
