# Nagios probe script for Dynamic DNS service

This is a script for monitoring status of Dynamic DNS service. The script 
should detect various possible issues of the service during operation and 
give corresponding error or warning message

The probes will try to update IP address of the probe hostname to actual IP
address of Nagios server. The probe hostname must be registered in the 
Dynamic DNS server in advance, and the corresponding secret for the hostname 
must be provided via command-line option together with the hostname

If the Dynamic DNS service is working, the probe will give one of the 
following messages and finish with exit code 0 (OK):

- OK - IP address not changed (in the case previous  IP address is the same
as updated)

- OK - IP address successfully updated

- OK - Server is working but updating IP fails due bad authentication 
(mostly bad secret)

If the Dynamic DNS service is unreachable, the probe will give one of the 
following messages and finish with exit code 2 (CRITICAL):

- CRITICAL - Server unreachable. Return code : $return_code (in the case 
service is down)

- CRITICAL - DNS error. Return code : $return_code (in the case of wrong 
server name or DNS error)

Other errors, if exist, are classified as UNKNOWN and will be classified 
later when more details of the probe tests are obtained and analyzed.

## Usage

```
Usage: ddns_probe.sh [-h] [-H DDNS_SERVER] [--probe-hostname PROBE_HOST]
                     [--probe-secret PROBE_SECRET]

Nagios probe test for Dynamic DNS service

Optional arguments:
        -h, --help, help                Display this help message and exit
        -H DDNS_SERVER, --hostname DDNS_SERVER
                                        Full FQDN of Dynamic DNS server
        --probe-hostname PROBE_HOSTNAME Registered hostname for probe test
        --probe-secret PROBE_SECRET     Corresponding secret for probe hostname
        -t TIMEOUT, --timeout TIMEOUT   Global timeout for probe test
```

## Examples

- Making probe test with default values for Dynamic DNS server and probe host/secret

```
$ ./ddns_probe.sh
OK - IP address successfully updated
```

- Making probe test with all parameters

```
$ ./ddns_probe.sh -H nsupdate.fedcloud.eu --probe-hostname probe.test.fedcloud.eu --probe-secret XXXXXX
OK - IP address not changed

