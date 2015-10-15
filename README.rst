Creating Docker Containers running Kofa
=======================================

With the given Dockerfile and script we can create a docker container
running `waeup.kofa` 1.3.3.

The following are merely notes to self.

Prepare Your Local Ubuntu
-------------------------

Install `docker`::

  $ sudo apt-get install docker.io

On Ubuntu "docker.io" is the official repo name of `docker`. This is
to distiguish from the same-named GUI app.


Install Basic Images (Ubuntu 14.04.3)
-------------------------------------

Pull a recent Ubuntu image from docker repository::

  $ docker pull ubuntu:14.04.3

This will fetch some hundred MBs.

You can play a bit with the freshly installed images.


Build Kofa
----------

This docker image of `waeup.kofa` is based on Ubuntu 14.04.3. We have
to get the Dockerfile and the `build.sh` script::

  $ git clone https://github.com/waeup/kofa-docker.git

This will put everything into a new local `kofa-docker` dir. Change to
it::

  $ cd kofa-docker/

Now start the build::

  $ docker build -t kofa .

This will take _lots_ of time, but should run until end.


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
