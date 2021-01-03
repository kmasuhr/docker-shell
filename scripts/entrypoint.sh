#!/usr/bin/env zsh

if [ ! -f /root/.initialized ]; then
  echo "Profile init"

  cp -R /profile_copy/. /root/
  cp -Rf /tmp/config/. /root/

  touch /root/.initialized
  echo "Profile initialized"
fi

zsh
