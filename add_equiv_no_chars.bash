#!/bin/bash

file="400bpsample.fastq"
char_count=`wc -m $file | sed s/$file//g`
char_add="I"

i=1

while [ $i -le $char_count ]; do echo -n $char_add >> $file; let i++; done
