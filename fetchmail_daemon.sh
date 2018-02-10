#!/bin/sh
echo "Start supervisor"
supervisord -c /etc/supervisord.conf

while true; do
	tail -f /var/log/messages
done	
