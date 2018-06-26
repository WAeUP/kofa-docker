FROM ubuntu:16.04

MAINTAINER Uli Fouquet <uli@waeup.org>

RUN apt-get update && apt-get install -y
RUN apt-get install -y python2.7-dev libxml2-dev libxslt1-dev \
                       zlib1g-dev python-virtualenv gcc g++
# see https://urllib3.readthedocs.org/en/latest/security.html#openssl-pyopenssl
RUN apt-get install -y libssl-dev libffi-dev
# libs needed/useful for Pillow image manipulations
RUN apt-get install -y libjpeg-dev libfreetype6-dev libtiff-dev libopenjpeg-dev
RUN apt-get install -y sudo wget git

# add user `kofa`
RUN useradd -ms /bin/bash kofa
# set password of user `kofa` and add to group 'sudo'
RUN echo kofa:kofa | chpasswd && adduser kofa sudo

# get sources
WORKDIR /home/kofa
RUN wget https://files.pythonhosted.org/packages/42/5f/71201506a0dd9392084708683c2288d53eb4ee74ccd654aefca4a2bc8455/waeup.kofa-1.6.tar.gz && tar -xzf waeup.kofa-1.6.tar.gz
RUN mv waeup.kofa-1.6 waeup.kofa

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

# remove `six` from versions config.
RUN cat /home/kofa/waeup.kofa/versions.cfg | grep -v six > versions_new.cfg
RUN mv versions_new.cfg /home/kofa/waeup.kofa/versions.cfg

RUN /home/kofa/py27/bin/buildout

# this dir will contain data you might want to be persistent
VOLUME ["/home/kofa/waeup.kofa/var/"]

CMD /home/kofa/waeup.kofa/bin/kofactl fg
