#!/bin/bash

source ${COMPASS_SOURCES_DIR}/include/shell-tools.shh

MSG	'Updating repos'
yum update -y

MSG	'Set timezone to America/Chicago'
rm /etc/localtime
ln -s /usr/share/zoneinfo/America/Chicago /etc/localtime
MSG	"Time: $(date)"
