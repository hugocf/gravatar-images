#!/usr/bin/env bash

# Created by Hugo Ferreira <hugo@mindclick.info> on 2011-02-07.
# Copyright (c) 2011 Mindclick. All Rights Reserved.
# Licensed under the BSD License: http://creativecommons.org/licenses/BSD
readonly BASEDIR=$(cd $(dirname $0) && pwd)
readonly CALLDIR=$(pwd)

# Script configuration
readonly TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
readonly DIR_OUTPUT="$BASEDIR/images-$TIMESTAMP"
readonly DIR_BACKUP="$DIR_OUTPUT/_sourcefile_"
readonly AVATAR_SIZE="200"
readonly AVATAR_FILE="avatar.png"
readonly QRCODE_SIZE="300"
readonly QRCODE_FILE="qrcode.png"
readonly SOURCE_FILE="emails.txt"

# Script functions
function usage () {
    echo "
Usage: `basename $0` [options] emailsfile

    -a value    size for the avatar image [$AVATAR_SIZE]
    -q value    size for the QR code image [$QRCODE_SIZE]
    -h          this usage help text
    
    emailsfile  plain text file with only 1 email address per line [$SOURCE_FILE]

This script iterates through the list of emails in a files, one per line, and
downloads from the Gravatar service (http://www.gravatar.com) their 
corresponding avatar images and QR codes (with a link to the Gravatar profile)

If a parameter is not supplied in the command line, the script prompts for 
confirmation of the default value, which means that in most cases you simply 
need to run the script 'as is':
    `basename $0`

Example:
    `basename $0` -a 100 -q 100 emails.txt"
    exit ${1:-0}
}

function askifempty () {
    ask_val="$1"; ask_default="$2"; ask_msg="$3"; ask_options="$4"  # pass "-s" for passwords
    if [[ -z "$ask_val" ]]; then
        read $ask_options -p "$ask_msg [$ask_default] " ask_val
    fi
    ask_val=$(echo ${ask_val:-$ask_default})
    echo "$ask_val"
}

# Check for errors
args=`getopt a:q:h $*`
[[ $? != 0 ]] && usage 1

# Evaluate each option
set -- $args
for i do
    case "$i" in
        -a) avatar_size=$2; shift; shift;;
        -n) qrcode_size=$2; shift; shift;;
        -h) usage;;
        --) shift; break;;
    esac
done

# Validate input parameters
avatar_size=$(askifempty "$avatar_size" "$AVATAR_SIZE" "Enter the size for the avatar:")
qrcode_size=$(askifempty "$qrcode_size" "$QRCODE_SIZE" "Enter the size for the QR code:")
source_file=$(askifempty "$1" "$BASEDIR/$SOURCE_FILE" "Enter the file name path with the list of emails:")

# Prepare the output directories
mkdir -p "$DIR_OUTPUT"
mkdir -p "$DIR_BACKUP"
cp -p "$source_file" "$DIR_BACKUP"      # backup the list of emails

# Process the emails
while read line
do
    echo
    echo "----------------------------------------"
    echo "PROCESSING: $line"
    echo
    email_hash=$(md5 -q -s "$line")
    mkdir -p "$DIR_OUTPUT/$line"
    curl "http://en.gravatar.com/avatar/$email_hash?s=$avatar_size" -o "$DIR_OUTPUT/$line/$AVATAR_FILE"
    curl "http://en.gravatar.com/$email_hash.qr?s=$qrcode_size" -o "$DIR_OUTPUT/$line/$QRCODE_FILE"
done < $source_file

echo "Done!"

