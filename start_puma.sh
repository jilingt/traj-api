#!/usr/bin/env bash
source ~/.bashrc
source ~/.profile
cd /home/jtang/traj-api && /root/.rbenv/shims/bundle exec puma -C config/puma.rb