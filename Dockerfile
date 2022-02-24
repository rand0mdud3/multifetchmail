FROM alpine:latest AS builder
LABEL maintainer="rand0mdud31@gmail.com"

RUN apk add --no-cache openssl openssl-dev git gcc musl-dev flex bison autoconf automake make gettext gettext-dev tar xz
WORKDIR /tmp
#RUN git clone https://github.com/just-containers/s6-overlay.git
RUN git clone https://github.com/rand0mdud3/s6-overlay.git
WORKDIR s6-overlay
RUN make ARCH=x86_64-linux-musl
WORKDIR /tmp/root
RUN tar -C . -Jxpf /tmp/s6-overlay/output/s6-overlay-noarch-*.tar.xz
RUN tar -C . -Jxpf /tmp/s6-overlay/output/s6-overlay-x86_64-*.tar.xz

WORKDIR /tmp
RUN git clone -b legacy_6x https://gitlab.com/fetchmail/fetchmail.git
WORKDIR fetchmail
RUN ./autogen.sh
RUN ./configure --prefix=/tmp/fetchmail-install --disable-nls
RUN make
RUN make install

FROM alpine:latest
RUN apk add --no-cache openssl
RUN adduser -D -H -s /bin/false fetchmail
COPY root/ /
COPY --from=builder /tmp/fetchmail-install/bin/fetchmail /usr/bin/
COPY --from=builder /tmp/root/ /

VOLUME ["/config"]
CMD ["/start.sh"]
