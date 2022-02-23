FROM alpine:latest AS builder
LABEL maintainer="rand0mdud31@gmail.com"

RUN apk add --no-cache openssl openssl-dev git gcc musl-dev flex bison autoconf automake make gettext gettext-dev
WORKDIR /tmp
RUN git clone -b legacy_6x https://gitlab.com/fetchmail/fetchmail.git
WORKDIR fetchmail
RUN ./autogen.sh
RUN ./configure --prefix=/tmp/fetchmail-install --disable-nls
RUN make
RUN make install

FROM alpine:latest
RUN apk add --no-cache openssl supervisor
RUN adduser -D -H -s /bin/false fetchmail
COPY root/ /
COPY --from=builder /tmp/fetchmail-install/bin/fetchmail /usr/bin/

VOLUME ["/config"]
CMD ["/start.sh"]
