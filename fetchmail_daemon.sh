#!/bin/sh
echo "Start supervisor"
supervisord -c /etc/supervisord.conf

while true; do
	tail -f /data/*/log/*.log
done	
