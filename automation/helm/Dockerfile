# TODO:
# * check sha256
# * check signature

FROM golang:1.21.0-bookworm as bench
ARG VERSION
ENV VERSION=${VERSION:-3.12.3}
WORKDIR /build
RUN git clone \
    --branch v${VERSION} \
    https://github.com/helm/helm .
RUN make && \
    mv bin/helm /usr/bin/helm

# Final image
FROM debian:bookworm as image
COPY --from=bench /usr/bin/helm /usr/bin/helm
WORKDIR /in
ENTRYPOINT [ "/usr/bin/helm" ]

# Output binary to host system
FROM scratch as output
COPY --from=bench /usr/bin/helm /
