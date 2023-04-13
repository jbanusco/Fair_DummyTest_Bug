#!/bin/bash

# This script creates the files needed to reproduce the fair minimum error

# Create a folder that contains some files with names sub-001.txt, sub-002.txt, etc. 
mkdir -p data

for i in {1..9}; do
    touch data/sub-00${i}.txt    
done
