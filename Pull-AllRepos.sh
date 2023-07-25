#!/usr/bin/env bash

GREEN="\e[32m"
RED="\e[41m"
ENDCOLOR="\e[0m"

function _pull() {
    git symbolic-ref --short HEAD
    git pull --all
}

# Change current directory to directory of script so it can be called from everywhere
SCRIPT_PATH=$(readlink -f "${0}")
SCRIPT_DIR=$(dirname "${SCRIPT_PATH}")
pushd "${SCRIPT_DIR}" > /dev/null


# Each subdirectory might be a repo
for dir in */; do

  pushd $dir > /dev/null

  # If it's a project pull all changes
  if [[ -d .git ]]; then
    echo -en "[${GREEN}${dir}${ENDCOLOR}] "
    _pull
  else
    
# Each subdirectory might be a repo
    for sub in */; do
      [[ ! -d $sub ]] && continue

      echo -en "[${GREEN}${dir}${sub}${ENDCOLOR}] "

      cd $sub >/dev/null

# Each subdirectory might be a repo
      if [[ -d .git ]]; then
        _pull
      else
        echo "not a repo"
      fi

      cd .. > /dev/null

    done
  fi

  popd > /dev/null
done

popd > /dev/null
