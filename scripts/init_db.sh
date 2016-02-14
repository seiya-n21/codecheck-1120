#!/bin/bash
bin/rake db:drop
bin/rake db:setup
bin/rails s