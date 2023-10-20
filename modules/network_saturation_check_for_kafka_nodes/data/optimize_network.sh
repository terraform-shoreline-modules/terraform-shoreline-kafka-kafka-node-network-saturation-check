

#!/bin/bash

# Script to optimize network configuration



# Stop Kafka services

sudo systemctl stop kafka.service



# Adjust network settings

sudo sysctl -w net.core.somaxconn=${NUM_CONNECTIONS}

sudo sysctl -w net.core.netdev_max_backlog=${BACKLOG_SIZE}

sudo sysctl -w net.ipv4.tcp_max_syn_backlog=${SYN_BACKLOG_SIZE}

sudo sysctl -w net.ipv4.tcp_syncookies=1

sudo sysctl -w net.ipv4.tcp_tw_reuse=1

sudo sysctl -w net.ipv4.tcp_fin_timeout=${FIN_TIMEOUT}



# Restart Kafka services

sudo systemctl start kafka.service