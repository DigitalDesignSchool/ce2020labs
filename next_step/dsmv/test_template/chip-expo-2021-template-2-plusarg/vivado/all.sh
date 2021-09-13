./compile.sh 
./elaborate.sh 

echo "" > global.txt

./c_run_0.sh
./c_run_1.sh
./c_run_2.sh
./c_run_3.sh
#./cvr.sh 
cat global.txt