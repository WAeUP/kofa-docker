FROM ubuntu:14.04.3

MAINTAINER Uli Fouquet <uli@waeup.org>

RUN apt-get update && apt-get install -y
RUN apt-get install -y python2.7-dev libxml2-dev libxslt1-dev \
                       zlib1g-dev python-virtualenv
# see https://urllib3.readthedocs.org/en/latest/security.html#openssl-pyopenssl
RUN apt-get install -y libssl-dev libffi-dev
# libs needed/useful for Pillow image manipulations
RUN apt-get install -y libjpeg-dev libfreetype6-dev libtiff-dev libopenjpeg-dev
RUN apt-get install -y sudo wget git

# fix link needed by Pillow
RUN ln -s /usr/include/freetype2 /usr/include/freetype2/freetype

# add user `kofa`
RUN useradd -ms /bin/bash kofa
# set password of user `kofa` and add to group 'sudo'
RUN echo kofa:kofa | chpasswd && adduser kofa sudo

# get sources
WORKDIR /home/kofa
RUN wget https://pypi.python.org/packages/source/w/waeup.kofa/waeup.kofa-1.3.3.tar.gz && tar -xzf waeup.kofa-1.3.3.tar.gz
RUN mv waeup.kofa-1.3.3 waeup.kofa
COPY build.sh /home/kofa/build.sh

# make sure, all added files belong to `kofa`
RUN chown -R kofa:kofa /home/kofa/

USER kofa
ENV HOME /home/kofa

# create a virtual env
RUN virtualenv py27

# install kofa -- this is the heavy part...
RUN /home/kofa/build.sh

CMD /bin/bash