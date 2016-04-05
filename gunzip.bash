#!/bin/bash

#make directory hierachy
projectname="Grant"
samplename="Grant"

homeDir="/home/jamtor"
projectDir="$homeDir/projects/$projectname"
inPath="$projectDir/raw_files"

#create an array of the input .gz files:
inFiles=( $(ls $inPath/*.fastq.gz | grep -v unpaired) )
echo -e
echo These are the inFiles:
echo ${inFiles[@]}

#scripts/logs directory
scriptsPath="$projectDir/scripts/QC"
logDir="$scriptsPath/logs"
mkdir -p $logDir

#fetch the input .gz files, make a copy of each to retain a gzipped file appended by .tmp,
#and gunzip the original input .gz files:
for file in ${inFiles[@]}; do
	echo -e
	echo The file used is: $file

	copy_line="cp $file "$file.tmp""
	
	echo -e
	echo This is the copy line:
	echo $copy_line

	gunzip_line="gunzip $file"

	echo -e
	echo This is the gunzip line:
	echo $gunzip_line

#rename the .tmp files to the original .gz file names:
	rename_line="mv "$file.tmp" $file"

    echo -e
    echo This is the rename_line:
    echo $rename_line

#define uniqueIDs for each sample to name the cluster jobs:
    uniqueID = `basename $file`

#submit each job to the cluster, holding the rename jobs until the corresponding gunzip jobs are
#complete:
	qsub -N COPY_$uniqueID -b y -wd $logDir -j y -R y -pe smp 1 -V $copy_line

	qsub -N GUNZIP_$uniqueID -hold_jid COPY_$uniqueID -b y -wd $logDir -j y -R y -pe smp 1 -V $gunzip_line
	
	qsub -N RENAME_$uniqueID -hold_jid GUNZIP_$uniqueID -b y -wd $logDir -j y -R y -pe smp 1 -V $rename_line

done;
