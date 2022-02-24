#!/bin/sh

SVCONF=/etc/services.d
FETCHMAILBASE=/var/lib/fetchmail.d

function addconfig {
    RCCONFIG=$1
    CONF=$2

    echo "Add config $RCCONFIG as $CONF"

    FMRC=$FETCHMAILBASE/$CONF/fetchmailrc

    mkdir -p $FETCHMAILBASE/$CONF
    cp $RCCONFIG $FMRC

    chown -R fetchmail:fetchmail $FETCHMAILBASE/$CONF
    chmod 0600 $FMRC

    SVCDIR=$SVCONF/$CONF
    mkdir -p $SVCDIR
    SVCRUN=$SVCDIR/run
    SVCFINISH=$SVCDIR/finish
    cat << EOF >>$SVCRUN
#!/bin/sh
export FETCHMAILHOME=$FETCHMAILBASE/$CONF
export HOME=$FETCHMAILBASE/$CONF
exec s6-setuidgid fetchmail /usr/bin/fetchmail -v --nodetach --nosyslog --pidfile /tmp/fetchmail-$CONF.pid
EOF
    chmod 0700 $SVCRUN

    cat << 'EOF' >>$SVCFINISH
#!/bin/sh
if test "$1" -eq 256 ; then
    echo "Killed by signal $2" >&2
else
    echo "Terminated with exit code $1" >&2
fi
sleep 5
EOF
    chmod 0700 $SVCFINISH
}

echo "Init fetchmailrc(s)"

rm -rf $FETCHMAILBASE
mkdir -p $FETCHMAILBASE
rm -rf $SVCONF
mkdir -p $SVCONF

for i in $(find /config -name "*.fetchmailrc")
do
    CONF=$(basename $i .fetchmailrc)
    addconfig $i $CONF
done

echo "Start S6"
exec /init
