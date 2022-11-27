#!/bin/bash
echo "">averages.txt
for i in {0..4}
do
   ns main.tcl $i
   python3 script.py
   ns main.tcl $i.1
   python3 script.py
   ns main.tcl $i.2
   python3 script.py
   ns main.tcl $i.3
   python3 script.py
   ns main.tcl $i.4
   python3 script.py
   ns main.tcl $i.5
   python3 script.py
   ns main.tcl $i.6
   python3 script.py
   ns main.tcl $i.7
   python3 script.py
   ns main.tcl $i.8
   python3 script.py
   ns main.tcl $i.9
   python3 script.py
done