#!/bin/bash
echo "">averages.txt
for i in {70..89}
do
   ns main.tcl $i
   python3 script.py
   ns main.tcl $i.2
   python3 script.py
   ns main.tcl $i.4
   python3 script.py
   ns main.tcl $i.6
   python3 script.py
   ns main.tcl $i.8
   python3 script.py
done