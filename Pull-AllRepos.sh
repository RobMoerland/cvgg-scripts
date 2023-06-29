#!/bin/bash

GREEN="\e[32m"
RED="\e[41m"
ENDCOLOR="\e[0m"

function pull() {
    git symbolic-ref --short HEAD
    git pull --all
}

dir=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
pushd $dir > /dev/null

for dir in */; do

  pushd $dir > /dev/null

  if [ -d .git ]; then
    echo -en "[${GREEN}${dir}${ENDCOLOR}] "
    pull
  else
    subdircount=`find . -maxdepth 1 -type d | wc -l`

    for sub in */; do
      [ ! -d $sub ] && continue

      echo -en "[${GREEN}${dir}${sub}${ENDCOLOR}] "

      cd $sub >/dev/null
      if [ -d .git ]; then
        pull
      else
        echo "not a repo"
      fi

      cd .. > /dev/null

    done
  fi

  popd > /dev/null
done

popd > /dev/null
