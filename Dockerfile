FROM alpine:latest
LABEL maintainer="rand0mdud31@gmail.com"

RUN apk add --no-cache openssl openssl-dev supervisor git gcc musl-dev flex bison tzdata autoconf automake gettext gettext-dev make

RUN adduser -D -H -s /bin/false fetchmail

WORKDIR /tmp
RUN git clone -b legacy_6x https://gitlab.com/fetchmail/fetchmail.git
WORKDIR fetchmail
RUN ./autogen.sh
RUN ./configure --prefix=/usr
RUN make
RUN make install

WORKDIR /tmp
RUN rm -rf fetchmail
RUN apk del openssl-dev git gcc musl-dev flex bison autoconf automake gettext-dev make

COPY root/ /

VOLUME ["/config"]
CMD ["/start.sh"]
