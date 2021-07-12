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

"$find_to_run" ../day_1 ../day_2 -name omdazz  \
| while read dir
  do
    copy_dir="${dir//omdazz/rzrd}"

    printf "copying '%s' into '%s'\n" "$dir" "$copy_dir" 1>&2

    if    ! rm -rf "$copy_dir" \
       || ! cp -r "$dir" "$copy_dir"
    then
      printf "$script: cannot copy '%s' into '%s'\n" "$dir" "$copy_dir" 1>&2
      exit 1
    fi
  done

#-----------------------------------------------------------------------------

"$find_to_run" ../day_1 ../day_2 -name top.v  \
| sed "s/\/top\.v//"  \
| while read dir
  do
    case "$dir" in
    *omdazz*)          board="omdazz"    ;;
    *piswords*)        board="piswords"  ;;
    *rzrd*)            board="rzrd"      ;;
    *zeowaa*)          board="zeowaa"    ;;
    *de10_lite*)       board="de10_lite" ;;
    *basys3*|*nexys4*) continue          ;;

    *)
      printf "$script: unrecognized directory '%s'\n" "$dir" 1>&2
      exit 1
    esac

    run_dir="$dir/run"

    printf "copying scripts into '%s'\n" "$run_dir" 1>&2

    if    ! rm -rf "$run_dir" \
       || ! mkdir  "$run_dir" \
       || ! cp -r all_intel_fpga_boards/* $board/* "$run_dir"
    then
      printf "$script: cannot copy into '%s'\n" "$run_dir" 1>&2
      exit 1
    fi
  done

exit 0
