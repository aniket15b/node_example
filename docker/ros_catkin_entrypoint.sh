#!/bin/bash

# Source ROS distro environment and local catwin workspace
source "/opt/ros/melodic/setup.bash" && source "/home/ros/ws/devel/setup.bash"

exec "$@"
