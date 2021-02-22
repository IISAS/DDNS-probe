# Nagios probe script for Dynamic DNS service

This is a script for monitoring status of Dynamic DNS service. The script 
should detect various possible issues of the service during operation and 
give corresponding error or warning message.

A short presentation of Dynamic DNS service and its probe test is available
at [here](https://github.com/tdviet/DDNS-probe/raw/main/Dynamic%20DNS%20service%20-%20OMB.pdf)

## Probe test for Dynamic DNS service

If the name of the service endpoint (given via "--endpoint-name" parameter)
is "nsupdate", the probe will perform test for Dynamic DNS service.
The probes will try to update IP address of the probe hostname to actual IP
address of Nagios server. The probe hostname must be registered in the 
Dynamic DNS server in advance, and the corresponding secret for the hostname 
must be provided via command-line option together with the hostname.

If the Dynamic DNS service is working, the probe will give one of the 
following messages and finish with exit code 0 (OK):

- OK - IP address not changed (in the case previous  IP address is the same
as updated),

- OK - IP address successfully updated,

- OK - Server is working but updating IP fails due bad authentication 
(mostly bad secret).

If the Dynamic DNS service is unreachable, the probe will give one of the 
following messages and finish with exit code 2 (CRITICAL):

- CRITICAL - Server unreachable. Return code : $return_code (in the case 
service is down),

- CRITICAL - DNS error. Return code : $return_code (in the case of wrong 
server name or DNS error).

Other errors, if exist, are classified as UNKNOWN and will be classified 
later when more details of the probe tests are obtained and analyzed.

## Probe test for DNS servers used by Dynamic DNS service

If the name of the endpoint is other than "nsupdate", the probe will perform
test for DNS server. It will try to get IP address of the probe hostname from 
the DNS server via "dig" command. If the DNS server responds, the probe will
print a message "OK - DNS server responded. Return value: IP address" and 
finish with exit code 0 (OK). If the server does not respond, , the probe will 
print the error message and return with exit code 2 (CRITICAL).

Other errors, if exist, are classified as UNKNOWN and will be classified 
later when more details of the probe tests are obtained and analyzed.

## Usage


```
Usage: ddns_probe.sh [-h] [--endpoint-name ENDPOINT_NAME] [-H SERVER] 
                     [--probe-hostname PROBE_HOST] [--probe-secret PROBE_SECRET]

Nagios probe test for Dynamic DNS service

Optional arguments:
        -h, --help, help                Display this help message and exit
        --endpoint-name ENDPOINT_NAME   Endpoint name (as in GOCDB)
        -H SERVER, --hostname SERVER    Hostname of server (endpoint URL in GOCDB)
        --probe-hostname PROBE_HOSTNAME Registered hostname for probe test
        --probe-secret PROBE_SECRET     Corresponding secret for probe hostname
        -t TIMEOUT, --timeout TIMEOUT   Global timeout for probe test

```

## Examples


- Making probe test of Dynamic DNS server:


```
$ ./ddns_probe.sh --endpoint-name nsupdate -H nsupdate.fedcloud.eu --probe-hostname probe.test.fedcloud.eu --probe-secret XXXXXX
OK - IP address not changed
```

- Making probe test for DNS server:


```
$ ./ddns_probe.sh --endpoint-name primary --hostname dns1.cloud.egi.eu --probe-hostname probe.test.fedcloud.eu
OK - DNS server responded. Return value: 147.213.65.175
```
