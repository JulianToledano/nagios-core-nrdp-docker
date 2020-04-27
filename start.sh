#!/bin/bash
sed -i "s#    //\"mysecrettoken\",  // <-- not a good token#\t\"${NRDP_TOKEN}\",#g" /usr/local/nrdp/server/config.inc.php
/etc/rc.d/init.d/nagios start
/usr/sbin/httpd -k start
tail -f /var/log/httpd/access_log /var/log/httpd/error_log