# About this Fork
This is a fork of [Robert C Sternberg's work](https://github.com/RobertCSternberg/ARPMonitorViaHTTP), all praise goes to him!

Changes done in this fork:
- Parametrisation via docker parameters
- No need for NET_ADMIN capability by moving to port 8080
- Possibility to scan more than one network at once

Please note that while adding these features no particular importance was given to validating the input parameters. This container is meant to be run on a trusted and secured host.

# ARP Monitor Via HTTP
This application is a network monitoring tool that allows you to view the ARP (Address Resolution Protocol) scanning results of a local network over HTTP on port 8080. This is especially useful for monitoring the uptime of devices that do not support traditional pinging methods over ICMP (Internet Control Message Protocol) or TCP (Transmission Control Protocol).


## Features
- Adjustable intermittence ARP Scanning: Offers an intermittently refreshed view of your local network's ARP scanning results.

- HTTP Accessibility: Provides easy access to the scan results over HTTP on port 8080, making it readily available for any device connected to the network.

- Compatibility: An ideal solution for devices that do not support traditional pinging methods over ICMP or TCP.

- Can scan multiple networks

- Adjustable frequency


## Setup
Setting up the ARP Monitor is straightforward. Follow the steps below:

Create a directory for the project and navigate into it:  
`mkdir networkscanner && cd networkscanner`

Load the Dockerfile, scan.sh, entry.sh, and nginx.conf files into the new directory. 

Build the Docker image for the network scanner:  
`docker build -t networkscanner .`

## Docker container
I encourage you to build the container yourself. If you do not want or cannot do so, there is a ready-made docker container (only x64, no arm, no arm64, no mips) available at https://hub.docker.com/r/alestrix/arpscanweb

## Usage
Run the Docker container in the background with network host and necessary capabilities. It should restart automatically if it stops for any reason:  
`docker run --restart=always --network=host -d --cap-add=NET_RAW networkscanner`

The scan defaults to the network 192.168.1.0/24. If you want to change this, add the network as parameter:  
`docker run --restart=always --network=host -d --cap-add=NET_RAW networkscanner 10.20.30.0/24`

If your system has multiple interfaces you can pass the interface name too:  
`docker run --restart=always --network=host -d --cap-add=NET_RAW networkscanner 10.20.30.128/25 enp3s0`

If you want to scan more than one network at once, you can repeat the two-touples:  
`docker run --restart=always --network=host -d --cap-add=NET_RAW networkscanner 10.20.30.128/25 enp3s0 192.168.10.0/24 wlp1s0`

Please note that this will not work:  
~~`docker run --restart=always --network=host -d --cap-add=NET_RAW networkscanner 10.20.30.128/25 192.168.10.0/24`~~

Network scanning default to once every minute. If you want a different frequency, use the `--time` option. tHE `--time` parameter needs to be the first parameter:  
`docker run --restart=always --network=host -d --cap-add=NET_RAW networkscanner --time 30 10.20.30.128/25 enp3s0 192.168.10.0/24 wlp1s0`

If you want the output in JSON format, add the `--json` parameter after the (optional) `--time` parameter:  
`docker run --restart=always --network=host -d --cap-add=NET_RAW networkscanner --json 10.20.30.128/25 enp3s0 192.168.10.0/24 wlp1s0`  
or  
`docker run --restart=always --network=host -d --cap-add=NET_RAW networkscanner --time 30 --json 10.20.30.128/25 enp3s0 192.168.10.0/24 wlp1s0`

JSON reults will look like this:
```
$ curl --silent http://localhost:8080 | jq
{
  "date": "24.November 2023 22:40:43 UTC",
  "results": [
    {
      "ip": "192.168.6.1",
      "mac": "f0:9f:c2:15:cd:d4",
      "rtt": "1.010",
      "vendor": "Ubiquiti Networks Inc."
    },
    {
      "ip": "192.168.7.62",
      "mac": "dc:a6:32:01:93:46",
      "rtt": "1.124",
      "vendor": "Raspberry Pi Trading Ltd"
    },
    {
      "ip": "192.168.7.62",
      "mac": "dc:a6:32:01:93:47",
      "rtt": "46.930",
      "vendor": "Raspberry Pi Trading Ltd"
    }
  ]
}

$ curl --silent http://localhost:8080 | jq ".results[] | select(.mac==\"dc:a6:32:01:93:47\").ip"
"192.168.7.62"
```

## Testing
To test whether the ARP Monitor is running correctly, you can send a request to the local server. The following command retrieves the ARP scan results:
curl http://localhost:8080/

This should return the ARP scanning results, which are updated every 60 seconds by default or whatever you configured via the `--time` parameter.

## Noted Configuration Options
- The default scan target is configured in `Dockerfile` as `CMD`.

# Conclusion
The ARP Monitor provides an efficient and straightforward method to monitor devices in a network, specifically those that do not support traditional pinging methods. By running it inside a Docker container, it is easy to deploy and manage across various environments.

For any queries or contributions, feel free to open an issue or make a pull request.

Enjoy monitoring your network!
