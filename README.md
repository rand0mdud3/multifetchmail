# multifetchmail

## What

tiny container (<6MiB) using alpine linux with current legacy\_6x fetchmail and dumb-init

## Why

To have the ability to receive your emails within seconds, without having to go through the hassle of setting up your own domain and MX relay. Use your favorite services that provides IMAP support and you too can get instantaneous emails delivered to your machine. Having a container makes it super easy to keep up to date with most recent fetchmail, as well as runnning it behind a VPN if you are paranoid.

## Install

```
docker run -it --name fetchmail -v ./fetchmail-config:/config rand0mdud3/multifetchmail
```

in a docker compose:

```
  fetchmail:
    container_name: fetchmail
    image: rand0mdud3/multifetchmail
    volumes:
      - ./fetchmail-config:/config
    restart: unless-stopped
```

## Configuration

Create multiple fetchmailrc files named as `<imapserver>.fetchmailrc` and adjust them to your own needs.

For each fetchmailrc file a separate fetchmail instance will be started (needed for IMAP idle processing since only one mail server can be accessed in this mode by fetchmail). Every output goes to stdout/stderr. fetchmail processes are restarted endlessly with a 5s delay.

Example fetchmail config(s) that you would store in the `./fetchmail-config` folder with the example above. Replace `<templated stuff>` with what works for you.

`./fetchmail-config/<imapserver>.fetchmailrc`:

```
set no bouncemail

poll <imapserver> protocol imap idletimeout 540
  username <imap username> there is <local user> here, has password <imap password> and wants nokeep, fetchall, ssl, idle
  smtphost <smtp server>
  smtpaddress <smtp local domain>
```

Not that some servers have broken IDLE implementation but still support it (it is the case of iCloud or imap.free.fr for e.g.), in this case you can try appending `forceidle` to the config:

```
  username <imap username> there is <local user> here, has password <imap password> and wants nokeep, fetchall, ssl, idle and forceidle
```

the `idletimeout` is also important. The default value in RFCs is around ~30 minutes, but alas a lot of servers don't respect that RFC. For e.g., in my experience, gmail drops connection after ~10min. Setting this value below your provider's timeout will guarantee IDLE works reliably.

## Reference

https://github.com/rand0mdud3/multifetchmail

## Thanks

@maberle for putting together maberle/multifetchmail which this container is based on.
