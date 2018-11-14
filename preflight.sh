#!/bin/sh
#cganote@js-169-53:~/docker-ctat-galaxy$ grep "^galaxy:" /etc/passwd
#galaxy:x:1450:998::/home/galaxy:/bin/false
#cganote@js-169-53:~/docker-ctat-galaxy$ echo $?
#0

if [[ ! $(grep "^galaxy:" /etc/passwd) ]]; then
    echo "No galaxy found"
    useradd -r -L -M --uid 1450 galaxy --shell /bin/false
else
    echo "Found galaxy user."
fi

## If there is a resource library location set, go ahead and set it to be owned by galaxy
if [[ -e $RESOURCE_LIB ]]; then
    owner=$(stat -c "%U" $RESOURCE_LIB)
    echo $owner
    if [[ $owner && $owner != "galaxy" ]]; then
	echo -n "Resource lib currently belongs to $owner. Chowning resource lib to galaxy..."
	if $(chown -R galaxy $RESOURCE_LIB); then
	    echo -n ".done.\n"
	else
	    echo "Something went wrong with chown. Are you using sudo? $?"
	fi

    fi
    ## Check to see how much space is in that directory
    dfstr=$(df -hk $RESOURCE_LIB | sed -n '1!p' )
    total=$(echo $dfstr | awk '{ printf $3; }')
    free=$(echo $dfstr | awk '{ printf $4; }')
    free=$(( $free / 1024 / 1024 ))
    if [[ $free < 70 ]]; then
	echo "You don't have enough room in $RESOURCE_LIB to start a new download. Looks like you have ${free}GB free. Did you already download the resources? Proceed with caution."
    else
	echo "You have ${free}GB free, you should be good to run the downloader scripts when you launch CTAT Docker Galaxy."
    fi
else
    echo "No RESOURCE_LIB environment variable found. If you want to be able to use all of CTAT tools, it's a good idea to run this script again after setting RESOURCE_LIB to the path where you want to store ~70GB of resource files. Make sure you have the space!"
fi
