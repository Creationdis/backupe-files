#!/bin/bash
# Create a script to install and configure HAProxy on lb-01 server
# Configure HAProxy to send traffic to web-01 and web-02 servers
# Distribute requests using a round-robin algorithm
# Make sure that HAProxy can be managed via an init script

# Update package lists and install HAProxy
sudo apt-get -y update
sudo apt-get -y install haproxy

# Define HAProxy configuration
haproxy_config="/etc/haproxy/haproxy.cfg"

# Create a function to add configuration to the HAProxy config file
add_config() {
    config="$1"
    echo "$config" | sudo tee -a "$haproxy_config"
}

# Define HAProxy configuration
server_config="
frontend creationdis_frontend
    bind *:80
    mode http
    default_backend creationdis_backend

backend creationdis_backend
    balance roundrobin
    server 367659-web-01 52.207.208.21:80 check
    server 367659-web-02 54.146.74.86:80 check
"

# Add the HAProxy configuration to the config file
add_config "$server_config"

# Enable HAProxy to start at boot
echo "ENABLED=1" | sudo tee -a /etc/default/haproxy

# Test the HAProxy configuration
sudo haproxy -c -f "$haproxy_config"

# Restart HAProxy service
sudo service haproxy restart
