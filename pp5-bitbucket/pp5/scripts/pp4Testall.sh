#!/bin/bash
mkdir -p myout
make clean
make
scripts/maketestpp4.sh
FILES=samples-pp4/*.out
for f in $FILES
do
	temp=$(basename $f)
	mo=${temp%%.*}
	echo "Processing $f and myout/$mo.decaf files..."
	diff -w $f myout/$mo.decaf
done
