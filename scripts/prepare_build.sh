#!/bin/bash

apt-get update -qq
apt-get install -y -qq sqlite3 libsqlite3-dev nodejs
cp config/secrets.yml.example config/secrets.yml
