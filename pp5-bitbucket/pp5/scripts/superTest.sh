#!/bin/bash
mkdir -p myout
make clean
make

FILES=samples/*.decaf
for f in $FILES
do
    rm myout/out1 myout/out2
    ./dcc < $f &> myout/out1
    solutions/dcc < $f &> myout/out2
    if [ $(wc -l < myout/out1) -gt 10 ]; then
        echo $f
        diff -w myout/out2 myout/out1 &> /dev/null
        if [ $? -eq 0 ]; then
            echo "ALL GOOD!"
        else
            echo "***ERROR***"
        fi
        echo ""
    else
        echo $f
        echo "LOTS OF DIFF"
        cat myout/out1
        echo ""
    fi
done
