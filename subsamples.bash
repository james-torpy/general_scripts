#!/bin/bash

#This script subsamples the first 400 000 lines of each .fastq file and saves it to a subsampl file

#make directory hierachy
projectname="Grant"
samplename="Grant"

homeDir="/home/jamtor"
projectDir="$homeDir/projects/$projectname"
inPath="$projectDir/raw_files"

#create an array of the input .gz files:
inFiles=( $(ls $inPath/*.fastq | grep -v unpaired) )
echo -e
echo These are the inFiles:
echo ${inFiles[@]}

#scripts/logs directory
scriptsPath="$projectDir/scripts/QC"
logDir="$scriptsPath/logs"
mkdir -p $logDir

#fetch the input .fastq files, take the first 400 000 lines and save it to a subsample file
for inFile in ${inFiles[@]}; do
	echo -e
	echo The inFile used is: $inFile

	#create names for the output files:
	out_filePrefix=``
	outFile="$inPath/`basename $inFile | sed s/proliferative_/sample/g`"

	echo The file will be saved as: $outFile
	subsample_line="head -400000 $inFile>$outFile"
	
	#submit each job to the cluster:
	qsub -N SUB_$uniqueID -b y -wd $logDir -j y -R y -pe smp 1 -V $subsample_line

done;
