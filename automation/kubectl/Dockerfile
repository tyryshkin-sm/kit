# TODO:
# * check sha256
# * check signature

FROM golang:1.21.0-bookworm as bench
ARG VERSION
ENV VERSION=${VERSION:-1.28.0}
WORKDIR /build
RUN git clone \
    --branch v${VERSION} \
    https://github.com/kubernetes/kubernetes .
RUN go build cmd/kubectl/kubectl.go && \
    chmod 0755 kubectl && \
    mv kubectl /usr/bin/kubectl

# Final image
FROM debian:bookworm as image
COPY --from=bench /usr/bin/kubectl /usr/bin/kubectl
WORKDIR /in
ENTRYPOINT [ "/usr/bin/kubectl" ]

# Output binary to host system
FROM scratch as output
COPY --from=bench /usr/bin/kubectl /
