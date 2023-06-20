# ARP Monitor Via HTTP
This application is a network monitoring tool that allows you to view the ARP (Address Resolution Protocol) scanning results of a local network over HTTP on port 80. This is especially useful for monitoring the uptime of devices that do not support traditional pinging methods over ICMP (Internet Control Message Protocol) or TCP (Transmission Control Protocol).


# Features
- Adjustable intermittence ARP Scanning: Offers an intermittently refreshed view of your local network's ARP scanning results.

- HTTP Accessibility: Provides easy access to the scan results over HTTP on port 80, making it readily available for any device connected to the network.

- Compatibility: An ideal solution for devices that do not support traditional pinging methods over ICMP or TCP.


# Setup
Setting up the ARP Monitor is straightforward. Follow the steps below:

Create a directory for the project and navigate into it:
`mkdir networkscanner && cd networkscanner`

Load the Dockerfile, run_scan.sh, and nginx.conf files into the new directory. 

Build the Docker image for the network scanner:
`docker build -t networkscanner .`

Run the Docker container in the background with network host and necessary capabilities. It will restart automatically if it stops for any reason:
`docker run --restart=always --network=host -d --cap-add=NET_RAW --cap-add=NET_ADMIN networkscanner`


# Testing
To test whether the ARP Monitor is running correctly, you can send a request to the local server. The following command retrieves the ARP scan results:
curl http://localhost:80/

This should return the ARP scanning results, which are updated based on your interval configured in run_scan.sh using the sleep command.


# Noted Configuration Options

- The ARP Scanning interval is configured in `run_scan.sh` using the sleep command and it's default is 60 seconds. 
- The network addresses to scan are configured in `run_scan.sh` using the arp-scan argument, the default is the 192.168.1.0/24 address block. 


# Conclusion
The ARP Monitor provides an efficient and straightforward method to monitor devices in a network, specifically those that do not support traditional pinging methods. By running it inside a Docker container, it is easy to deploy and manage across various environments.

For any queries or contributions, feel free to open an issue or make a pull request.

Enjoy monitoring your network!
