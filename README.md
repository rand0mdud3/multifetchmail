# docker-fetchmail

alpine linux with fetchmail, logrotate and supervisord

```
docker run -it --name fetchmail -v /fetchmail_config:/data maberle/docker-multifetchmail
```
# configuration
create multiple local `etc/<name>/fetchmailrc` files and adjust it to your own needs
 - let the postmaster run as fetchmail
```

For each <name> configuration a separate fetchmail instance will be started (needed for IMAP idle processing). The fetchmail processes will be monitored by supervisord.
The web interface for supervisord is enabled at port 9101.

The supervisord processes are logging to syslog. Syslogd logs into /var/log/messages.
