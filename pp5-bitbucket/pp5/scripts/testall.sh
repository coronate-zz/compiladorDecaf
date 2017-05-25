#!/bin/bash
mkdir -p myout
make clean
make
scripts/maketest.sh
FILES=samples/*.tac
for f in $FILES
do
	temp=$(basename $f)
	mo=${temp%%.*}
	echo "Comparing $f and myout/$mo.decaf files..."
	echo "===========================start=$f====================="
	diff -w $f myout/$mo.decaf
	echo "============================end==$f====================="
done
