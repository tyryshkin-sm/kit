# TODO:
# * check sha256
# * check signature

FROM haskell:9.2.8-buster AS bench
ARG VERSION
ENV VERSION=${VERSION:-2.12.0}
WORKDIR /build
RUN git clone \
    --branch v${VERSION} \
    https://github.com/hadolint/hadolint .
RUN cabal update && \
    cabal configure && \
    cabal build && \
    cabal install && \
    cp /root/.cabal/bin/hadolint /usr/bin/hadolint

# Target to output binary to host system
FROM scratch as output
COPY --from=bench /usr/bin/hadolint /
