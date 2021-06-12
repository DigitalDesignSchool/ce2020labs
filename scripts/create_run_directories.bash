#!/bin/bash

set +e  # Don't exit immediately if a command exits with a non-zero status

script=$(basename "$0")

#-----------------------------------------------------------------------------

# A workaround for a find problem when running bash under Microsoft Windows

find_to_run=find
true_find=/usr/bin/find

if [ -x "$true_find" ]
then
  find_to_run="$true_find"
fi

#-----------------------------------------------------------------------------

"$find_to_run" ../day_1 ../day_2 -name top.v  \
| sed "s/\/top\.v//" \
| while read dir
  do
    case "$dir" in
    *omdazz*)          board="omdazz"    ;;
    *piswords*)        board="piswords"  ;;
    *zeowaa*)          board="zeowaa"    ;;
    *de10_lite*)       board="de10_lite" ;;
    *basys3*|*nexys4*) continue          ;;

    *)
      printf "$script: unrecognized directory '%s'" "$dir" 1>&2
      exit 1
    esac

    echo $dir 1>&2

    if    ! rm -rf "$dir/run" \
       || ! mkdir  "$dir/run" \
       || ! cp -r all_intel_fpga_boards/* $board/* "$dir/run"
    then
      printf "$script: cannot copy into '%s'" "$dir/run" 1>&2
      exit 1
    fi
  done

exit 0
