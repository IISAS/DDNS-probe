#!/bin/bash
HOST="probe.test.fedcloud.eu"
SECRET=z8Yp6zZzJd
UPDATE_URL=nsupdate.fedcloud.eu/nic/update

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
        echo "OK - Update IP address successfully"
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
