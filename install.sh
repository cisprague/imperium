#!/bin/bash

sudo python setup.py clean --all install clean --all
sudo rm -R build dist Imperium.egg-info tmp
