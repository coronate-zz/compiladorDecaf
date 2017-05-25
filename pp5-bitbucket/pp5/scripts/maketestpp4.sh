#!/bin/bash

FILES=samples-pp4/*.decaf
for f in $FILES
do
	echo "Processing $f file..."
	./dcc < $f &> myout/$(basename $f)
done
