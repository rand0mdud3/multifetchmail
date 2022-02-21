#!/bin/sh

SVCONF=/etc/supervisord.conf
FETCHMAILBASE=/var/lib/fetchmail.d

function addconfig {
    RCCONFIG=$1
    CONF=$2

    echo addconfig $RCCONFIG as $CONF

    FMRC=$FETCHMAILBASE/$CONF/fetchmailrc

    mkdir -p $FETCHMAILBASE/$CONF
    cp $RCCONFIG $FMRC

    chown -R fetchmail:fetchmail $FETCHMAILBASE/$CONF
    chmod 0400 $FMRC

	cat << EOF >>$SVCONF

[program:$CONF]
environment=FETCHMAILHOME=$FETCHMAILBASE/$CONF
command=/usr/bin/fetchmail -v --nodetach --nosyslog --pidfile /tmp/fetchmail-$CONF.pid
autorestart=true
user=fetchmail
startsecs=2
startretries=10000
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
stderr_logfile=/dev/stderr
stderr_logfile_maxbytes=0
EOF
    chmod 0600 $FMRC
}

echo "Init fetchmailrc(s)"

rm -rf $FETCHMAILBASE
mkdir -p $FETCHMAILBASE
cp /etc/supervisord.conf.templ $SVCONF

for i in $(find /config -name "*.fetchmailrc")
do
    CONF=$(basename $i .fetchmailrc)
    addconfig $i $CONF
done

echo "Start supervisor"
supervisord -c /etc/supervisord.conf
