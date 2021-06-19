# ce2020labs
ChipEXPO 2020 Digital Design School Labs
Update for 2021 is in progress

How to work with this repository if you are using IntelFPGA / Altera boards:

1. Install Git:

For Ubuntu/Lubuntu: sudo apt install git
For Windows: go to https://git-scm.com/download/win, the download will start automatically.

Note that Git for Windows includes many Linux utilities: bash, find, sed, etc.

2. Install Intel FPGA Quartus Lite from https://fpgasoftware.intel.com/?edition=lite

3. Note that the current version of Quartus (20.1.1) has a bug in the USB driver. You have to install a patch to fix it. See the following URL for the instructions:

https://www.intel.com/content/altera-www/global/en_us/index/support/support-resources/knowledge-base/tools/2021/why-does-the-intel--fpga-download-cables-drivers-installation-fa.html

4. For Windows, install the Gnu version of zip.
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

9.1. We don't want to mix the source files with the generated files in the same directory.
9.2. A student should be able to start any project from scratch at any moment, discarding all changes made by Quartus.
9.3. Some of Quartus's changes are Quartus version-specific. We don't want this - the examples should run on any version of Quartus starting from ~13.1.
9.4. We don't want to accidentally check in some temporary file into the Git tree.

In order to resolve this issue, we created a Bash script create_run_directories.bash that creates temporary directories with the copies of the relevant .qsf and .sdc files.
The script traverses the source tree looking for the top.v files. When the script finds one, it creates a directory named "run" with the copies of the project files from the scripts subdirectory.
These run subdirectories are not supposed to be checked in, they are ignored by the git commit command because we put "run/" into the .gitignore file.

To run this scripts under Linux:

cd ~/github/ce2020labs/scripts
./create_run_directories.bash

To run this scripts under Windows:

cd c:\github\ce2020labs\scripts
bash create_run_directories.bash

Under Windows you can also associate .bash extension with bash.exe executable and run the script automatically in Far Commander by pressing Enter.

Each created run directory contains the following files:

top.qpf - the main project file. You can load the project into Quartus GUI by doing "File | Open project" menu. Note that practically everyone confuses this menu item with a "File | Open file" menu item from time to time.
Note that top.qpf is empty. It is OK because Quartus gets the actual information from top.qsf and top.sdc located in the same subdirectory as top.qpf.

top.qsf - Tcl file with the project settings, like bindings of FPGA pins to signal names.
top.sdc - Tcl file with the timing settings.

Scripts to use in the command line:

x_simulate.bash   - runs either Icarus Verilog or Mentor / Siemens EDA ModelSim.
x_synthesize.bash - runs x_configure.bash if the synthesis is successful.
x_configure.bash  - requires x_synthesize.bash to run first.

Scripts in each run directory used by other scripts:

x_setup.bash      - is sourced by other x_* scripts.
xx_gtkwave.tcl    - is used by x_simulate.bash
xx_modelsim.tcl   - is used by x_simulate.bash

10. You can use create_ce2020labs_zip.bash script to create a zip file for anybody who does not want to use git, bash scripts or command line.

To run this scripts under Linux:

cd ~/github/ce2020labs/scripts
./create_ce2020labs_zip.bash

To run this scripts under Windows:

cd c:\github\ce2020labs\scripts
bash create_ce2020labs_zip.bash

This script does the following:

1. Runs create_run_directories.bash to create all the necessary temporary directories.
2. Clones schoolRISCV repository for the 3rd day lab exercises from https://github.com/zhelnio/schoolRISCV .
3. Create two zip files with timestamps:

ce2020labs_before_20210613_111848.zip - a file with simple exercises to check that the system is ready for the rest of the lab (Quartus is installed, all drivers are working with a board a student has).
ce2020labs_20210613_111844.zip - a complete package.

These zip files can be put into some web location for download. After a student gets this file, all he has to do is to unzip it, run Quartus GUI and open projects from the appropriate run directories. All work can be done in GUI, without command line.

------------------------------------------------------------------------------

The Appendix: Git cheat sheet.

# To config your name and email

git config --global user.name  "Your Name"
git config --global user.email your@email.com

# To clone a git repository from github

git clone https://github.com/DigitalDesignSchool/ce2020labs.git

# To update your copy of repository files with the changes made by other people

git pull

# To check the status - changed, added, deleted files

git status

# To check the differenced against the repository

git diff

# To add new files or directories (recursively)

git add file_or_directory_name

# To undo uncommitted changes to a file or a directory

git checkout file_or_directory_name

# To undo uncommitted changes all files in this directory, including uncommitted deletions

git checkout file_or_directory_name

# To commit changes with a comment.
# Note that -a option automatically stages all modifications and file deletions, but not the additions.
# You need to add the files manually doing "git add" operation.
# !!! Note 1: Please run "git status" and "git diff" before any commit. Undoing committed and especially pushed changes is more difficult than undoing uncommitted changes.
# !!! Note 2: Please put a meaningful comment for each commit.

git commit -a -m "A meaningful comment"

# To officially publish all your committed changes in git repository (such as GitHub)

git push

You can browse the repository history on http://github.com itself using web browser interface.

If you need Git to ignore some files, put them in .gitignore. Such files may include automatically generated binaries, temporaries, or unrelated files you don't want to checkin or to appear in git status. Please read about .gitignore in Git documentation before doing it.

If you need to do anything non-trivial (merging, undoing committed or pushed changes), please carefully consult Git documentation. Otherwise you may introduce mess, bugs, or checkin some large binary files polluting the repository.
