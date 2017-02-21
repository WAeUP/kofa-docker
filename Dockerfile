FROM ubuntu:14.04.5

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
RUN wget https://pypi.python.org/packages/ed/0f/0b30fcf8c113b11967c1481668b38b4b9e32f256eb366f73b70ff960872f/waeup.kofa-1.5.tar.gz && tar -xzf waeup.kofa-1.5.tar.gz
RUN mv waeup.kofa-1.5 waeup.kofa

# make sure, all added files belong to `kofa`
RUN chown -R kofa:kofa /home/kofa/

USER kofa
ENV HOME /home/kofa

# create a virtual env
RUN virtualenv -p /usr/bin/python2.7 py27

# install kofa -- this is the heavy part...
WORKDIR /home/kofa/waeup.kofa
RUN /home/kofa/py27/bin/pip install --upgrade pip
RUN /home/kofa/py27/bin/python /home/kofa/waeup.kofa/bootstrap.py
RUN /home/kofa/waeup.kofa/bin/buildout

# this dir will contain data you might want to be persistent
VOLUME ["/home/kofa/waeup.kofa/var/"]

CMD /home/kofa/waeup.kofa/bin/kofactl fg
