#!/bin/bash

#-----------------------------------------------------------------------------

# Find a license

license_dir=$HOME/licenses

export list=("$license_dir/"*License.dat)
export LM_LICENSE_FILE=${list[0]}

if [ ! -f "$LM_LICENSE_FILE" ]
then
  printf "Get license file from \"%s\" and put it into \"$license_dir\".\n" \
    "https://www.intel.com/content/www/us/en/programmable/support/support-resources/support-centers/licensing.html"

  exit 1
fi

printf "Using \"$LM_LICENSE_FILE\" as a license file.\n"

#-----------------------------------------------------------------------------

# Find an installation

vsim_pattern="$HOME"/intelFPGA_lite/'*'/questa_fse/bin/vsim
vsim=("$HOME"/intelFPGA_lite/*/questa_fse/bin/vsim)

if [ ! -f "$vsim" ]
then
  printf "Cannot locate vsim using \"$vsim_pattern\" pattern. Is Questa-Intel FPGA Edition installed?"
  exit 1
fi

printf "Using \"$vsim\" to run Questa.\n"

#-----------------------------------------------------------------------------
