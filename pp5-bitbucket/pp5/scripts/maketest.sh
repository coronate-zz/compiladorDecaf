#!/bin/bash

FILES=samples/*.decaf
for f in $FILES
do
	echo "Compiling $f file..."
	./dcc -d tac < $f &> myout/$(basename $f)
done
