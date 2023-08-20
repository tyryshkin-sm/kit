# TODO:
# * check sha256
# * check signature

FROM golang:1.21.0-bookworm as bench
ARG VERSION
ENV VERSION=${VERSION:-1.5.0}
WORKDIR /build
RUN git clone \
    --branch v${VERSION} \
    https://github.com/hashicorp/terraform .
RUN go build && \
    mv terraform /usr/bin/terraform

# Final image
FROM debian:bookworm as image
COPY --from=bench /usr/bin/terraform /usr/bin/terraform
WORKDIR /in
ENTRYPOINT [ "/usr/bin/terraform" ]

# Output binary to host system
FROM scratch as output
COPY --from=bench /usr/bin/terraform /
