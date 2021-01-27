#!/bin/bash

# Default values for Dynamic DNS server, hostname and secret
# Make sure to have valid secret
SERVER=nsupdate.fedcloud.eu
HOST="probe.test.fedcloud.eu"
SECRET=J8wbeqK2A2

# Usage info
show_help() {
cat << EOF
Usage: ${0##*/} [-h] [-H DDNS-SERVER] [--probe-host PROBE-HOST] 
                     [--probe-secret PROBE_SECRET]

Nagios probe test for Dynamic DNS service

Optional arguments:
	-h, --help, help		Display this help message and exit
	-H DDNS-SERVER, --hostname DDNS-SERVER
					Full FQDN of Dynamic DNS server
	--probe-host PROBE-HOST		Registered hostname for probe test
	--probe-secret PROBE_SECRET	Corresponding secret for probe hostname
EOF
}



while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -H|--hostname)
    SERVER="$2"
    shift # past argument
    shift # past value
    ;;
    --probe-hostname)
    HOST="$2"
    shift # past argument
    shift # past value
    ;;
    --probe-secret)
    SECRET="$2"
    shift # past argument
    shift # past value
    ;;
    -h|--help|help)
    show_help
    exit 0
    shift # past argument
    ;;
    *)
    echo "Invalid argument: $key"
    exit 1
    ;;
esac
done

UPDATE_URL=$SERVER/nic/update

return_value=$(curl -s https://$HOST:$SECRET@$UPDATE_URL)
return_code=$?

# Printing debug info
#echo "Return code is  $return_code" 
#echo "Return value is $return_value"

if (($return_code == 0)); then
    if [[ $return_value =~ ^"nochg" ]]; then
        echo "OK - IP address not changed"
        exit 0
    elif [[ $return_value =~ ^"good" ]]; then
        echo "OK - IP address successfully updated"
        exit 0
    elif [[ $return_value =~ ^"badauth" ]]; then
        echo "OK - Server is working but updating IP fails due bad authentication"
        exit 0
    else
        echo "UNKNOWN - Server reachable but something is wrong. Return value : $return_value"
        exit 3
    fi
elif (($return_code == 7)); then
        echo "CRITICAL - Server unreachable. Return code : $return_code"
        exit 2
elif (($return_code == 6)); then
        echo "CRITICAL - DNS error. Return code : $return_code"
        exit 2
else
        echo "UNKNOWN - Return code : $return_code"
        exit 3
fi
