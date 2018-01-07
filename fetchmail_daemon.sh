#!/bin/sh
echo "Start supervisor"
supervisord -c /etc/supervisord.conf

/bin/ash
