#!/bin/bash
./dcc < $1 &> myout/out1
solutions/dcc < $1 &> myout/out2
echo "diff resutls"
echo "========================"
diff -w myout/out2 myout/out1
echo "========================"
echo ""
echo "output of your compiler!"
echo "========================"
cat myout/out1
