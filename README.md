# docker-fetchmail

alpine linux with fetchmail, logrotate and supervisord

```
docker run -it --name fetchmail -v /fetchmail_config:/data maberle/multifetchmail
```
# configuration

create multiple fetchmailrc files named as '<name>.fetchmailrc' and adjust it to your own needs.

For each fetchmailrc file a separate fetchmail instance will be started (needed for IMAP idle processing since only one mail server can be accessed in this mode by fetchmail). The fetchmail processes will be monitored by supervisord.
The web interface for supervisord is enabled at port 9101.

The supervisord processes are logging to syslog. Syslogd writes into /var/log/messages and is logged to stdout.
