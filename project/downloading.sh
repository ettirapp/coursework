#!/bin/bash
#
# description:
#   fetches stop and frisk data files
#
# usage: ./downloading.sh
#
# requirements: curl or wget
#
# author: jake hofman
#

# set a relative path for the data
# (use current directory by default)
DATA_DIR=.

# change to the data directory
cd $DATA_DIR

# loop over each year
for year in 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013
do
    # download the zip file
    # alternatively you can use wget if you don't have curl
    # wget $url
    url=https://www1.nyc.gov/assets/nypd/downloads/zip/analysis_and_planning/stop-question-frisk/sqf-${year}-csv.zip
    curl -O $url

    # define local file names
    file=`basename $url`
    csv=${file//.zip/}".csv"

    # unzip the downloaded file
    unzip -p $file > $csv

    # remove the zip file
    rm $file
    done
done
