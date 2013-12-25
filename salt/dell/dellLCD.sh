#!/bin/bash
#
# Set LCD status (hostname, load, ganeti master) 
#

load="$(cat /proc/loadavg | awk '{print $3}')"
ganeti_master_hostname="$(/usr/sbin/gnt-cluster getmaster)"
hostname="$(hostname)"
omconfig="/opt/dell/srvadmin/bin/omconfig"

lcd_msg="${hostname} ${load}"

# check if this node is ganeti master
if [ "${ganeti_master_hostname}" == "$(hostname)" ]; then
  lcd_msg="$lcd_msg MASTER"
fi

"${omconfig}" chassis frontpanel lcdindex=1 config=custom text="${lcd_msg}" > /dev/null
