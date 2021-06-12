#!/bin/bash

set +e  # Don't exit immediately if a command exits with a non-zero status

root_name=ce2020labs
pwd=$PWD
root=$pwd/..
uarch=$root/day_3/uarch

if ! rm -rf ${root_name}_*.zip
then
    printf "$script: cannot remove old zip files" 1>&2
    exit 1
fi

if ! ./create_run_directories
then
    printf "$script: cannot create run directories" 1>&2
    exit 1
fi

if ! rm -rf $uarch || ! mkdir $uarch || ! cd $uarch
then
    printf "$script: cannot clean and create a new writable directory for schoolRISCV" 1>&2
    exit 1
fi

if ! git clone https://github.com/zhelnio/schoolRISCV
then
    printf "$script: cannot clone schoolRISCV repository" 1>&2
    exit 1
fi

if ! cd $root/..
then
    printf "$script: something is wrong with directory structure or permissions" 1>&2
    exit 1
fi

if ! zip -r $pwd/${root_name}_$(date '+%Y%m%d_%H%M%S').zip $root_name
then
    printf "$script: cannot zip the main package" 1>&2
    exit 1
fi

if ! zip -r -x$root_name/before/.gitignore \
  $pwd/${root_name}_before_$(date '+%Y%m%d_%H%M%S').zip \
  $root_name/before
then
    printf "$script: cannot zip the \"before\" package" 1>&2
    exit 1
fi

exit 0
