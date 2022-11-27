#!/bin/bash
for i in {70..90}
do
   ns main.tcl -$i
   python3 script.py
done