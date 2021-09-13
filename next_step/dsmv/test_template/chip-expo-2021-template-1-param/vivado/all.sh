./compile.sh 

echo "" > global.txt
./elaborate_0.sh 
./c_run.sh
./elaborate_1.sh 
./c_run.sh
./elaborate_2.sh 
./c_run.sh
./elaborate_3.sh 
./c_run.sh
#./cvr.sh 
cat global.txt