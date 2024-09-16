#!/bin/bash

dir_fix=$1
group="nph162"

if [ -z $dir_fix ]
then
    echo "USAGE"
    echo "$0 dir_to_fix_permissions"
    exit
fi

echo "running: find $dir_fix -user $USER | xargs chgrp $group"
find $dir_fix -user $USER | xargs chgrp $group
echo "running: find $dir_fix -user $USER | xargs chmod ug+rwX"
find $dir_fix -user $USER | xargs chmod ug+rwX
echo "running: find $dir_fix -type d -user $USER | xargs chmod g+s"
find $dir_fix -type d -user $USER | xargs chmod g+s
