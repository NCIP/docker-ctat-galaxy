#!/bin/bash

# If you set your RESOURCE_LIB variable in your local environment, you will want to invoke this script the following way:
#   sudo -E bash preflight.sh
# This is because sudo invokes the script as a privileged user, and the environment might be different for that user! If you want to keep
# your environment variables, use the -E flag.

# A note. On systems I tested, the grep command will return exit code 0 if it found something, and exit 1 if not. I'm relying on this.
# grep "^galaxy:" /etc/passwd
# galaxy:x:1450:998::/home/galaxy:/bin/false
# echo $?
# 0

if [ ! $(grep "^galaxy:" /etc/passwd) ]; then
    echo "No galaxy found - creating a user for you."
    useradd -r -M --uid 1450 galaxy --shell /bin/false
    usermod -L galaxy
else
    echo "Found galaxy user. Not going to re-create it."
fi

## If there is a resource library location set, go ahead and set it to be owned by galaxy
if [ -n "${RESOURCE_LIB}" ]; then
    echo "Resource lib found at $RESOURCE_LIB."
    echo "Checking for galaxy owner..."
    owner=$(stat -c "%U" $RESOURCE_LIB)    
    if [[ $owner && $owner != "galaxy" ]]; then
	echo -n "Resource lib currently belongs to $owner. Chowning resource lib to galaxy..."
	if $(chown -R galaxy $RESOURCE_LIB); then
	    echo -n ".done.\n"
	else
	    echo "Something went wrong with chown. Are you using sudo? $?"
	fi
    else
	echo "Galaxy user owns Resource lib; ready for use."
    fi
    ## Check to see how much space is in that directory
    dfstr=$(df -k $RESOURCE_LIB | sed -n '1!p' )
    total=$(echo $dfstr | awk '{ printf $3; }')
    free=$(echo $dfstr | awk '{ printf $4; }')
    ## Convert to GB
    free=$(( $free / 1024 / 1024 ))
    if [[ $free -lt 70 ]]; then
	echo "You don't have enough room in $RESOURCE_LIB to start a new download. Looks like you have ${free}GB free. Did you already download the resources? Proceed with caution."
    else
	echo "You have ${free}GB free, and CTAT resources require 70GB. You should be good to run the downloader scripts when you launch CTAT Docker Galaxy."
    fi
else
    echo "No RESOURCE_LIB environment variable found. If you want to be able to use all of CTAT tools, it's a good idea to run this script again after setting RESOURCE_LIB to the path where you want to store ~70GB of resource files. Make sure you have the space!"
fi

