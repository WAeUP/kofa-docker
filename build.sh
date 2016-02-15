#!/bin/bash

source /home/kofa/py27/bin/activate
pip install --upgrade pip
pip install pyopenssl ndg-httpsclient pyasn1

cd waeup.kofa/
python bootstrap.py
./bin/buildout
