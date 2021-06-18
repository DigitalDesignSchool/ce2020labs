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

We resolve this issue by
TODO
