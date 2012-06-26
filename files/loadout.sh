#!/bin/bash

# Set apps

for APP in Allura* Forge* NoWarnings
do
    cd $APP
    python setup.py develop
    cd ..
done

# Load out directories for Allura

for SCM in git svn hg
do
    mkdir -p ~/var/scm/$SCM
    chmod 777 ~/var/scm/$SCM
    sudo ln -s ~/var/scm/$SCM /tmp
done