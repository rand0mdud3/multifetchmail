#!/bin/sh

SVCONF=/etc/services.d
FETCHMAILBASE=/var/lib/fetchmail.d
INIT=/init

function addconfig {
    RCCONFIG=$1
    CONF=$2

    echo "Add config $RCCONFIG as $CONF"

    FMRC=$FETCHMAILBASE/$CONF/fetchmailrc

    mkdir -p $FETCHMAILBASE/$CONF
    cp $RCCONFIG $FMRC

    chown -R fetchmail:fetchmail $FETCHMAILBASE/$CONF
    chmod 0600 $FMRC

    SVCRUN=$SVCONF/$CONF.sh
    cat << EOF >>$SVCRUN
#!/bin/sh
export FETCHMAILHOME=$FETCHMAILBASE/$CONF
export HOME=$FETCHMAILBASE/$CONF
while true; do
    su -s /bin/sh -p fetchmail -c "exec /usr/bin/fetchmail -v --nodetach --nosyslog --pidfile /tmp/fetchmail-$CONF.pid"
    sleep 5
done
EOF
    chmod 0700 $SVCRUN

    echo "$SVCRUN &" >> $INIT
}

echo "Init fetchmailrc(s)"

rm -rf $FETCHMAILBASE
mkdir -p $FETCHMAILBASE
rm -rf $SVCONF
mkdir -p $SVCONF

echo "#!/usr/bin/dumb-init /bin/sh" > $INIT
chmod 0755 $INIT

for i in $(find /config -name "*.fetchmailrc")
do
    CONF=$(basename $i .fetchmailrc)
    addconfig $i $CONF
done

echo "Start dumb init"
cat << EOF >>$INIT
while true; do
    sleep 1d
done
EOF

exec $INIT
