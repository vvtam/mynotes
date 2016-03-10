#!/bin/bash
cd ~/path/to/project
git remote update -p
git checkout -f origin/master
git submodule update --init