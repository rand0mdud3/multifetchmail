FROM alpine:latest AS builder
LABEL maintainer="rand0mdud31@gmail.com"
RUN apk add openssl-dev git gcc musl-dev flex bison autoconf automake make gettext-dev dumb-init tzdata
WORKDIR /tmp
RUN git clone -b legacy_6x https://gitlab.com/fetchmail/fetchmail.git
WORKDIR fetchmail
RUN ./autogen.sh
ENV CFLAGS=-Os
RUN ./configure --prefix=/tmp/fetchmail-install --disable-nls
RUN make
RUN make install

FROM alpine:latest
RUN adduser -D -H -s /bin/false fetchmail
COPY root/ /
COPY --from=builder /lib/libcrypto.so.1.1 /lib/
COPY --from=builder /tmp/fetchmail-install/bin/fetchmail /usr/bin/dumb-init /usr/bin/
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo

VOLUME ["/config"]
CMD ["/start.sh"]
