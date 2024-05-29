Creating Docker Containers Running Kofa
=======================================

With the given Dockerfile and script we can create a docker container
running `waeup.kofa` 1.8.1.

The following are merely notes to self.

Shortcut (tl;rd):
-----------------

Build and run a cluster of one ZEO server serving `kofa` and one ZEO client
(building takes a long time)::

  $ docker compose up -d

Watch your instance running at http://localhost:8080


Longcut:
--------

Build::

  $ docker build --no-cache --pull -t kofa .

Run (as daemon)::

  $ docker run -p 8080:8080 -d kofa

Get a shell::

  $ docker run --rm -i -t kofa /bin/bash

Workdir inside container::

  /home/kofa

User credentials inside container::

  kofa:kofa


Prepare Your Local Ubuntu
-------------------------

Install `docker`::

  $ sudo apt-get install docker.io

On Ubuntu "docker.io" is the official repo name of `docker`. This is
to distinguish from the same-named GUI app.


Install Basic Images (Ubuntu)
-----------------------------

You can pull a recent base image, we yet use Ubuntu, beforehand::

  $ docker pull ubuntu:20.04

This will fetch some hundred MBs. If you do not, the base image will
be fetched during build process.

You can play a bit with the freshly installed images.


Build and start a ZEO powered cluster of `kofa` nodes
-----------------------------------------------------

We start with the most advanced scenario, because it is the easiest to set up
and run. That is: running kofa in a `docker compose`-based container cluster.

This can be done by one command::

  $ docker compose up -d

will pull all needed images, build the `kofa` images for ZEO server and ZEO
client and then start these. The build can take 15 minutes or more but is
necessary only when running for the first time or after code updates.

To start a cluster of one ZEO servers and two clients, you can do::

  $ docker compose up --scale zclient=2 -d

Please note, that the ZEO clients need a config file that tells them where the
server can be found. This config file is bind mounted from
`etc/zope-zeoclient.conf` in the local directory.

In this file the ZEO server URL and port are set in the two `server` stanzas inside the
`<zeoclient>` sections::

   ...
   <zeoclient>
     server myserver.localnet:8100
     ...
   </zeoclient>
   ...

By default the value set there is `zserver:8100`, a hostname and port that is
given by the local zserver service in `docker-compose.yaml`.



Build Kofa
----------

This official docker image of `waeup.kofa` is based on Ubuntu
20.04. We have to get the Dockerfile and the `build.sh` script::

  $ git clone https://github.com/waeup/kofa-docker.git

This will put everything into a new local `kofa-docker` dir. Change to
it::

  $ cd kofa-docker/

Now start the build::

  $ docker build -t kofa .

This will take _lots_ of time, but should run until end.
Use ``--no-cache`` to build from scratch, even if parts of the image
where built successfully already.


Build ZEO components
--------------------

The local `Dockerfile` not only supports building stock `kofa` but also to
build a ZEO-server and a ZEO client to run kofa inside a cluster of containers.
The proper tool to orchestrate these containers is `docker compose`.

To build a ZEO server or client from the `Dockerfile` you have to give the
respective targets::

  $ docker build --target zeo_client -t kofa-zclient .
  $ docker build --target zeo_server -t kofa-zserver .

A ZEO server can then be started like this::

  $ docker run --rm -v zserver1:/home/kofa/waeup.kofa/var -d kofa-zserver

with all content created inside `var/` stored in a persistent volume.

It is, however, not easy to create a network of servers and clients - except
you use `docker compose` which makes this task very managable. We therefore
explain usage of ZEO clients and servers in the `docker compoase` section
above.


Tag Container
-------------

Optionally, you might like to tag the built container::

  $ docker tag kofa:latest kofa:x.y.z

where ``x.y.z`` is a version number. We tag our images like this:

  `22.04-1.8.1`

where `22.04` is the Ubuntu version used and `1.8.1` the Kofa version installed.


Run Kofa
--------

When finished, you can run your freshly installed `kofa` instance like
this::

  $ docker run -it --rm -p 8080:8080 kofa

or like this::

  $ docker run -it --rm -p 8080:8080 kofa:20.04-1.8.1

if you prefer a certain version.


After startup you should be able to reach the portal on your local
port 8080. Open

  http://localhost:8080/

in a browser (`grok`/`grok` as credentials).

Please note that changes you make will remain in the running single
container only. Persistent data can be saved with shared
folders/volumes as shown below.

When the container stops, all data will be lost.


Run Kofa (from Shell)
---------------------

Instead of starting a `kofa` instance immediately, you can also start
a shell and enter the container to do whatever you like there. In that
case you run a container with::

  $ docker run -p 8080:8080 -it kofa /bin/bash

(note the trailing ``/bin/bash``) which will drop you into a shell
inside the docker container. Change to `waeup.kofa/` and start the
server manually::

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

You can also restart stopped containers and reattach to them::

  $ docker start <container-name>
  $ docker attach <container-name>

will bring you back into the container.

You can also run arbitrary commands inside a container. The command `/bin/bash`
above is only one example. You could, for instance, run the tests inside the
container like this::

  $ docker run -it --rm kofa /home/kofa/waeup.kofa/bin/test


Run Kofa - w/o Entering the Container
-------------------------------------

Of course you can run `kofa` without entering the container and doing
complex things at all::

  $ docker run -p 8080:8080 -d kofa

will give you access to a running `kofa` instance on your localhost
port ``8080``. The default credentials are ``grok`` / ``grok``.

You can make sure everything worked wit `docker ps`::

  $ docker ps -l
  CONTAINER ID        IMAGE        COMMAND                CREATED             STATUS              PORTS               NAMES
  9033a6bd4baf        kofa         "/home/kofa/waeup.ko   4 minutes ago       Up 4 minutes                            loving_franklin

A running docker instance can be stopped with::

  $ docker stop loving_franklin
  loving_franklin

and be restarted with::

  $ docker start loving_franklin
  loving_franklin

and `kofa` should be accessible at ``http://localhost:8080/`` again.

You can follow logs printed to stdout with::

  $ docker logs loving_franklin
  /home/kofa/waeup.kofa/bin/paster serve /home/kofa/waeup.kofa/parts/etc/themed-deploy.ini
  2016-07-02 09:15:49,013 INFO [zope.app.generations] main db: evolving in mode EVOLVEMINIMUM
  2016-07-02 09:15:49,018 INFO [zope.app.generations] main db/zope.app: running install generation

but it makes more sense to create a shared folder where you can store
persistent data, including several logs and data files.

To remove a container completely, use ``docker rm`` as shown above. Or use the
`--rm` when running a container. This will dispose the container immediately
after it was stopped without any further intervention.


Kofa Data Persistence
---------------------

Data in Kofa is stored in a database called `ZODB`. This database is a
simple file in the ``var/`` folder of the Kofa instance installed.

If you do changes and the database is not persisted, all changes will
be lost on restart.

To make your changes last, you must make the ``var/`` folder
persistent. You can do so for instance by::

  $ docker run -p 8080:8080 -it --rm -v kofadata1:/home/kofa/waeup.kofa/var/ kofa

Here we create a volume named `kofadata1` that stores the content of the
in-container path `/home/kofa/waeup.kofa/var/`. That is the directory we want
to make persistent.

The container will be removed when stopped (because we specified `--rm`), but
the data in the given path will survive inside the named volume.

When we start a new container with the same volume, we get the data from the
first container.

Let's do it, this time with the container detatching from the commandline
(specified by `-d`)::

  $ docker run -p 8080:8080 -d --rm -v kofadata1:/home/kofa/waeup.kofa/var/ kofa

The new container will provide the same data as the first one. Changes will
also stay.

The exact path of the named volume can be determined by running::

  $ docker inspect <VOLUME_NAME>

In our case that would be

  $ docker inspect kofadata1


Building on Other Base Images
-----------------------------

By default we support Ubuntu 20.04 as base. Apart from that we provide
limited support for other images::

  xenial/    # Ubuntu 16.04
  bionic/    # Ubuntu 18.04

You can build/tag/run respective images like this::

  $ docker build -t kofa:xenial xenial/
  $ docker tag kofa:latest kofa:xenial-x.y.z
  $ docker run --net=host -t -i kofa:xenial

Other commands for handling non-default images apply as shown above.
