#!/bin/bash
echo $1 | ./dcc -d tac &> myout/out1
echo $1 | solutions/dcc -d tac &> myout/out2
echo "diff resutls"
echo "========================"
diff -w myout/out2 myout/out1
echo "========================"
echo ""
echo "output of your compiler!"
echo "========================"
cat myout/out1
