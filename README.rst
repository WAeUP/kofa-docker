Creating Docker Containers Running Kofa
=======================================

With the given Dockerfile and script we can create a docker container
running `waeup.kofa` 1.4.1.

The following are merely notes to self.

Prepare Your Local Ubuntu
-------------------------

Install `docker`::

  $ sudo apt-get install docker.io

On Ubuntu "docker.io" is the official repo name of `docker`. This is
to distinguish from the same-named GUI app.


Install Basic Images (Ubuntu)
-----------------------------

You can pull a recent base image, we yet use Ubuntu, beforehand::

  $ docker pull ubuntu:14.04.4

This will fetch some hundred MBs. If you do not, the base image will
be fetched during build process.

You can play a bit with the freshly installed images.


Build Kofa
----------

This official docker image of `waeup.kofa` is based on Ubuntu
14.04.4. We have to get the Dockerfile and the `build.sh` script::

  $ git clone https://github.com/waeup/kofa-docker.git

This will put everything into a new local `kofa-docker` dir. Change to
it::

  $ cd kofa-docker/

Now start the build::

  $ docker build -t kofa .

This will take _lots_ of time, but should run until end.


Tag Container
-------------

Optionally, you might like to tag the buildt container::

  $ docker tag kofa:latest kofa:x.y.z

where ``x.y.z`` is a version number.


Run Kofa
--------

When finished, you can run you freshly installed instance like this::

  $ docker run --net=host -t -i kofa

whch will drop you into a shell on the 'virtual' docker
container. Change to `waeup.kofa` and start the server::

  (container) $ cd waeup.kofa
  (container) $ ./bin/kofactl fg

After startup you should be able to reach the portal on your local
port 8080. Open

  http://localhost:8080/

If you stop the container shell (type 'exit'), the container will
still exist::

  $ docker ps --all
  CONTAINER ID     IMAGE            COMMAND                CREATED          STATUS                   PORTS            NAMES
  b74700439486     kofa:latest      "/bin/sh -c '/bin/ba   59 seconds ago   Exited (0) 23 seconds ago                 hopeful_ptolemy


To remove it, run::

  $ docker rm <container-name>

with the `<container-name>` listed before.

To see locally available images, run::

  $ docker images

An image can be removed with::

  $ docker rmi <image-id>

where `<image-id>` is a hex number as listed by the command
before.

You can also start containers stopped before and reattach to them::

  $ docker start <container-name>
  $ docker attach <container-name>

will bring you back into the container.


Building on Other Base Images
-----------------------------

By default we support Ubuntu 14.04 as base. Apart from that we provide
limited support for other images::

  xenial/    # Ubuntu 16.04

You can build/tag/run respective images like this::

  $ docker build -t kofa:xenial xenial/
  $ docker tag kofa:latest kofa:xenial-x.y.z
  $ docker run --net=host -t -i kofa:xenial

Other commands for handling non-default images apply as shown above.
