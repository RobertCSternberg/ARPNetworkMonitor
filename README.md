# About this Fork
This is a fork of [Robert C Sternberg's work](https://github.com/RobertCSternberg/ARPMonitorViaHTTP), all praise goes to him!

Changes done in this fork:
- Parametrisation via docker parameters
- No need for NET_ADMIN capability by moving to port 8080
- Possibility to scan more than one network at once

Please note that while ading these features no particular importance was given to validating the input parameters. This container is meant to be run on a trusted and secured host.

# ARP Monitor Via HTTP
This application is a network monitoring tool that allows you to view the ARP (Address Resolution Protocol) scanning results of a local network over HTTP on port 8080. This is especially useful for monitoring the uptime of devices that do not support traditional pinging methods over ICMP (Internet Control Message Protocol) or TCP (Transmission Control Protocol).


## Features
- Adjustable intermittence ARP Scanning: Offers an intermittently refreshed view of your local network's ARP scanning results.

- HTTP Accessibility: Provides easy access to the scan results over HTTP on port 8080, making it readily available for any device connected to the network.

- Compatibility: An ideal solution for devices that do not support traditional pinging methods over ICMP or TCP.


## Setup
Setting up the ARP Monitor is straightforward. Follow the steps below:

Create a directory for the project and navigate into it:  
`mkdir networkscanner && cd networkscanner`

Load the Dockerfile, scan.sh, entry.sh, and nginx.conf files into the new directory. 

Build the Docker image for the network scanner:  
`docker build -t networkscanner .`

## Usage
Run the Docker container in the background with network host and necessary capabilities. It will restart automatically if it stops for any reason:  
`docker run --restart=always --network=host -d --cap-add=NET_RAW networkscanner`

The scan defaults to the network 192.168.1.0/24. If you want to change this, add the network as parameter:  
`docker run --restart=always --network=host -d --cap-add=NET_RAW networkscanner 10.20.30.0/24`

If your system has multiple interfaces you can pass the interface name too:  
`docker run --restart=always --network=host -d --cap-add=NET_RAW networkscanner 10.20.30.128/25 enp3s0`

If you want to scan more than one network at once, you can repeat the two-touples:  
`docker run --restart=always --network=host -d --cap-add=NET_RAW networkscanner 10.20.30.128/25 enp3s0 192.168.10.0/24 wlp1s0`

Please note that this will not work:  
~~`docker run --restart=always --network=host -d --cap-add=NET_RAW networkscanner 10.20.30.128/25 192.168.10.0/24`~~


## Testing
To test whether the ARP Monitor is running correctly, you can send a request to the local server. The following command retrieves the ARP scan results:
curl http://localhost:8080/

This should return the ARP scanning results, which are updated based on your interval configured in run_scan.sh using the sleep command.


# Noted Configuration Options

- The ARP Scanning interval is configured in `entry.sh` using the sleep command and its default is 60 seconds.
- The default scan target is configured in `Dockerfile`.

# Conclusion
The ARP Monitor provides an efficient and straightforward method to monitor devices in a network, specifically those that do not support traditional pinging methods. By running it inside a Docker container, it is easy to deploy and manage across various environments.

For any queries or contributions, feel free to open an issue or make a pull request.

Enjoy monitoring your network!
