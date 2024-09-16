#!/bin/bash

dir_fix=$1

if [ -z $dir_fix ]
then
    echo "USAGE"
    echo "$0 dir_fix"
    exit
fi

echo "running: find $dir_fix -user $USER | xargs chgrp coldqcd"
find $dir_fix -user $USER | xargs chgrp coldqcd
echo "running: find $dir_fix -user $USER | xargs chmod o-rwx"
find $dir_fix -user $USER | xargs chmod o-rwx
echo "running: find $dir_fix -user $USER | xargs chmod ug+rwX"
find $dir_fix -user $USER | xargs chmod ug+rwX
echo "running: find $dir_fix -type d -user $USER | xargs chmod g+s"
find $dir_fix -type d -user $USER | xargs chmod g+s
