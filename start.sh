#!/bin/sh

run()
{ 
    mksvconf
    # run cron daemon, which executes the logrotate job
    crond
    # run fetchmail as endless loop with reduced permissions
    su -s /bin/sh -c '/bin/sh /bin/fetchmail_daemon.sh' fetchmail
}

run

