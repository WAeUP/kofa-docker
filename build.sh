#!/bin/bash

source /home/kofa/py27/bin/activate
pip install --upgrade pip
pip install pyopenssl ndg-httpsclient pyasn1
pip install distribute
pip install --upgrade setuptools==0.6c11

cd waeup.kofa/
python bootstrap.py
pip install --upgrade zc.buildout==2.1.0
pip install --upgrade setuptools==0.6c11
./bin/buildout
