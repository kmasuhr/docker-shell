#!/usr/bin/env zsh

set -e

if [ ! -f /root/.initialized ]; then
  echo "Profile init"

  cp -R /profile_copy/root/. /root/
  cp -Rf /tmp/config/. /root/

  touch /root/.custom.zsh
  touch /root/.initialized
  echo "Profile initialized"
fi

cp -Rf /tmp/config/. /root/

zsh
