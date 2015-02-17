Dependencies for CRITs 3.1.0
============================

## NOTE:
This repo is only kept here for the existing 3.1.0 release. It is no longer
needed if you are setting up a new install by tracking a branch and will be
going away once the next version of CRITs is released. The core project now
comes with a bootstrap script which handles dependency installation.

This repository contains some of the dependencies for CRITs.

## Installing this software

Once you have downloaded the repository, you will want to run the
install_dependencies.sh script which comes with it.

`sudo -E ./install_dependencies.sh`

This will take care of using the OS's package management system to download some
basic packages before installing the local content. This will also install the
necessary Python packages using pip.
