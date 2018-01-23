# docker-fetchmail
[![](https://images.microbadger.com/badges/image/cguenther/docker-fetchmail.svg)](https://microbadger.com/images/cguenther/docker-fetchmail "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/cguenther/docker-fetchmail.svg)](https://microbadger.com/images/cguenther/docker-fetchmail "Get your own version badge on microbadger.com")

alpine linux with fetchmail, logrotate and supervisord

```
docker run -it --name fetchmail -v /fetchmail_config:/data maberle/docker-multifetchmail
```
# configuration
create multiple local `etc/<name>/fetchmailrc` files and adjust it to your own needs
 - let the postmaster run as fetchmail
 - use the /data/<name>/log/fetchmail.log logging path for correct logrotate interop
```

For each <name> configuration a separate fetchmail instance will be started (needed for IMAP idle processing). The fetchmail processes will be monitored by supervisord.
The web interface for supervisord is enabled at port 9101.

The supervisord process logs directly into the mountpoint `/data/log/supervisord.log`. Each fetchmail process logs into a separate log directoy /data/<name/log/fetchmail-stdout.log
 and /data/<name/log/fetchmail-stderr.log
