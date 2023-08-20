# TODO:
# * check sha256
# * check signature

FROM golang:1.21.0-bookworm as bench
ARG VERSION
ENV VERSION=${VERSION:-0.46.0}
WORKDIR /build
RUN git clone \
    --branch v${VERSION} \
    https://github.com/grafana/k6 .
RUN go build && \
    mv k6 /usr/bin/k6

# Final image
FROM debian:bookworm as image
COPY --from=bench /usr/bin/k6 /usr/bin/k6
WORKDIR /in
ENTRYPOINT [ "/usr/bin/k6" ]

# Output binary to host system
FROM scratch as output
COPY --from=bench /usr/bin/k6 /
