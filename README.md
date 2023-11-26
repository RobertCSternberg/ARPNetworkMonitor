# ARP Network Monitor
This application is a network monitoring tool that allows you to view the ARP (Address Resolution Protocol) scanning results of a local network over HTTP on port 8080. This is especially useful for monitoring the uptime of devices that do not support traditional pinging methods over ICMP (Internet Control Message Protocol) or TCP (Transmission Control Protocol).

Please note no particular importance was given to validating the input parameters. This script is meant to be run on a trusted and secured host with sanitized inputs.

## Features
- Offers a frequently refreshed view of your local networks' ARP scanning results.
- HTTP Accessibility: Provides easy access to the scan results over HTTP on port 8080, making it readily available for any device connected to the network.
- Compatibility: An ideal solution for target devices that do not support traditional pinging methods over ICMP or TCP.
- Can scan multiple networks
- Adjustable frequency
- Optional JSON output
- Possibility to scan more than one network at once
- Parametrisation of target networks, interfaces, and scan frequency via docker parameters
- No need for NET_ADMIN capability by moving to port 8080

## Setup
Setting up the ARP Monitor is straightforward. Follow the steps below:

Create a directory for the project and navigate into it:  
`mkdir networkscanner && cd networkscanner`

Load the Dockerfile, scan.sh, entry.sh, and nginx.conf files into the new directory. 

If you want to change the default, edit the `CMD` line in the `Dockerfile`.

Build the Docker image for the network scanner:  
`docker build -t networkscanner .`

## Docker container
I encourage you to build the container yourself. At a later point in time prebuilt containers might become available.  

## Usage
Run the Docker container in the background with network host and necessary capabilities and default target network (192.168.1.0/24). It should restart automatically if it stops for any reason:  
`docker run --restart=always --network=host -d --cap-add=NET_RAW networkscanner`

If you want to change the default target network, add the network in CIDR format as parameter:  
`docker run --restart=always --network=host -d --cap-add=NET_RAW networkscanner 10.20.30.0/24`

If your system has multiple interfaces you can pass the interface name too:  
`docker run --restart=always --network=host -d --cap-add=NET_RAW networkscanner 10.20.30.128/25 enp3s0`

If you want to scan more than one network at once, you can repeat the two-touples:  
`docker run --restart=always --network=host -d --cap-add=NET_RAW networkscanner 10.20.30.128/25 enp3s0 192.168.10.0/24 wlp1s0`

Please note that this will not work as you will always need a two-touple when scanning multiple networks:  
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
  "date": "2023-11-24T23:43:15Z+0000",
  "results": [
    {
      "ip": "192.168.6.1",
      "mac": "f0:9f:c2:15:cd:d4",
      "rtt": "1.010",
      "vendor": "Ubiquiti Networks Inc."
    },
    {
      "ip": "192.168.6.120",
      "mac": "74:eb:80:66:3f:12",
      "rtt": "446.083",
      "vendor": "Samsung Electronics Co.,Ltd"
    },
    {
      "ip": "192.168.7.62",
      "mac": "dc:a6:32:01:93:46",
      "rtt": "1.124",
      "vendor": "Raspberry Pi Trading Ltd"
    }
  ]
}

$ curl --silent http://localhost:8080 | jq -r '.results[] | select(.mac=="dc:a6:32:01:93:46").ip'
192.168.7.62
```

To troubleshoot the log output might be handy:  
`docker logs networkscanner`

You can kill and delete the docker container using  
`docker rm -f networkscanner`

## Testing
To test whether the ARP Monitor is running correctly, you can send a request to the local server. The following command retrieves the ARP scan results:
`curl http://localhost:8080/`

This should return the ARP scanning results, which are updated every 60 seconds by default or whatever you configured via the `--time` parameter.

## Notable Configuration Options
- The default scan target is configured in `Dockerfile` as `CMD`.
- Everything can be set when initially starting the container with `docker run`. Details see [above](#usage).

# Conclusion
The ARP Monitor provides an efficient and straightforward method to monitor devices in a network, specifically those that do not support traditional pinging methods. By running it inside a Docker container, it is easy to deploy and manage across various environments.

For any queries or contributions, feel free to open an issue or make a pull request.

Enjoy monitoring your network!
