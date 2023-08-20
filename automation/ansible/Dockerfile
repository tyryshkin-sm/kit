FROM alpine:3.14
ARG VERSION
ENV VERSION=${VERSION:-8.2.0}
RUN apk add -U \
    alpine-sdk \
    rust \
    cargo \
    py3-pip \
    libffi-dev \
    openssl-dev \
    python3-dev \
    openssh-client
RUN pip3 install ansible==${VERSION}
ENTRYPOINT [ "/usr/bin/ansible" ]
