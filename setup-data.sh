B#!/bin/bash

pip install ephemeris

galaxy-wait -g http://localhost:8080 -v

if [[ $? == 0 ]]; then
    echo "Galaxy is ready to go"
else
    echo "Something went wrong, getting out of here!"
    exit 1
fi
run-data-managers --user 'admin@galaxy.org' --password 'admin' -g http://localhost:80 --config run_data_managers.yaml

