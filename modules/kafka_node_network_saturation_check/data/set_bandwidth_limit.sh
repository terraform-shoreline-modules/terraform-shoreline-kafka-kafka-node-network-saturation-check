

#!/bin/bash



# Set the network interface name and bandwidth limit

INTERFACE=${INTERFACE_NAME}

LIMIT=${NEW_BANDWIDTH_LIMIT}



# Check the current bandwidth limit

CURRENT_LIMIT=$(sudo tc qdisc show dev $INTERFACE | awk '{if ($1 == "hfsc") print $6}')



if [ "$CURRENT_LIMIT" == "$LIMIT" ]; then

  echo "Bandwidth limit is already set to $LIMIT"

else

  # Update the bandwidth limit

  sudo tc qdisc replace dev $INTERFACE root handle 1: hfsc default 1

  sudo tc class replace dev $INTERFACE parent 1: classid 1:1 hfsc ls rate $LIMIT ul rate $LIMIT

  echo "Bandwidth limit has been set to $LIMIT"

fi