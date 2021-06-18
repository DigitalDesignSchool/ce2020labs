# ce2020labs
ChipEXPO 2020 Digital Design School Labs

How to work with this repository if you are using IntelFPGA / Altera boards:

1. Install Git:

For Ubuntu/Lubuntu: sudo apt install git
For Windows: go to https://git-scm.com/download/win, the download will start automatically.

Note that Git for Windows includes many Linux utilities: bash, find, sed etc.

2. Install Intel FPGA Quartus Lite from https://fpgasoftware.intel.com/?edition=lite

3. Note that the current version of Quartus (20.1.1) has a bug in USB driver. You have to install a patch to fix it. See the following URL for the instructions:

https://www.intel.com/content/altera-www/global/en_us/index/support/support-resources/knowledge-base/tools/2021/why-does-the-intel--fpga-download-cables-drivers-installation-fa.html

4. For Windows, install Gnu version of zip.
Download it from https://sourceforge.net/projects/gnuwin32/files/zip/3.0/zip-3.0-setup.exe/download
This is necessary for a script that is going to create a user package.

5. Add Quartus and ModelSim (included in Quartus) to the path - it will be necessary to run it in the command line.
For Windows, in System Properties / Environment Variables / Path add the following paths:

C:\intelFPGA_lite\20.1\modelsim_ase\win32aloem
C:\intelFPGA_lite\20.1\quartus\bin64
%PROGRAMFILES(x86)%\GnuWin32\bin

6. Create a directory where you would like to put the tree. For example,  you can create C:\github under Windows or ~/github under Linux.

7. In the command line, cd to the directory.

8. git clone https://github.com/DigitalDesignSchool/ce2020labs.git

9. Quartus creates temporary files in the same directory as the project file (a file with the extention .qpf) resides.
Quartus also edits the setting file, a file with .qsf extension.

This is very annoying for multiple reasons:

9.1. We don't want to mix the source files with generated files in the same directory.
9.2. A student should be able to start any project from scratch at any moment, discarding all changes made by Quartus.
9.3. Some of Quartus changes are Quartus version-specific. We don't want this - the examples should run on any version of Quartus starting from ~13.1.
9.4. We don't want to accidentally check in some temporary file into the Git tree.

We resolve this issue we created a Bash script create_run_directories.bash that creates temporary directories with the copies of the relevant .qsf and .sdc files.
The script traverses the lab package tree looking for top.v files. When the scrip founds one, it creates a directory named "run" with the copies of the project files from the scripts subdirectory.
These run subdirectories are not supposed to be checked in - they are ignored by git checkin because "run/" is put into .gitignore file.

To run this scripts under Linux:

cd ~/github/ce2020labs/scripts
./create_run_directories.bash

To run this scripts under Windows:

cd c:\github\ce2020labs\scripts
bash create_run_directories.bash

You can also associate .bash extension with Bash and run the script automatically in Far Commander by pressing Enter.

Each created run directory contains the following files:

top.qpf - the main project file. Can be loaded into Quartus GUI using "File | Open project" menu (everybody confuses it with "File | Open file" menu from time to time).
Note that top.qpf is empty. It is OK because Quartus gets the actual information from top.qsf and top.sdc.

top.qsf - Tcl file with the project settings, like binding FPGA pins to signal names.
top.sdc - Tcl file with timing settings.

Scripts to use in the command line:

x_simulate.bash - run either Icarus Verilog or Mentor / Siemens EDA ModelSim
x_synthesize.bash - runs x_configure.bash if the synthesis is successful
x_configure.bash - requires x_synthesize.bash to run first

Scripts in each run directory used by other scripts:

x_setup.bash is sourced by other x_* scripts.
xx_gtkwave.tcl - is used by x_simulate.bash
xx_modelsim.tcl - is used by x_simulate.bash

10. You can use create_ce2020labs_zip.bash script to create a zip file for anybody who does not want to use git, bash scripts or command line.
ce2020labs_before_20210613_111848.zip 
ce2020labs_20210613_111844.zip

TODO
