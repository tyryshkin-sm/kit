# TODO:
# * check sha256
# * check signature
# * pin deb package versions
# * support multiple ansible playbooks

FROM golang:1.21.0-bullseye as bench
ARG PACKER_VERSION
ENV PACKER_VERSION=${PACKER_VERSION:-1.9.2}
WORKDIR /build
RUN git clone \
    --branch v${PACKER_VERSION} \
    https://github.com/hashicorp/packer.git . \
    && \
    go build -o /usr/bin/packer

# Final image
FROM debian:bullseye
ARG ANSIBLE_VERSION
ENV ANSIBLE_VERSION=${ANSIBLE_VERSION:-8.3.0}
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    qemu \
    qemu-kvm \
    qemu-utils \
    qemu-system \
    virt-manager \
    virt-viewer \
    python3-pip \
    openssh-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN pip3 install --no-cache-dir ansible==${ANSIBLE_VERSION}
COPY --from=bench /usr/bin/packer /usr/bin/packer
ENV PACKER_LOG 0
ENV PACKER_CACHE_DIR "/cache"
ENV PKR_VAR_iso_url "https://releases.ubuntu.com/22.04.2/ubuntu-22.04.2-live-server-amd64.iso"
ENV PKR_VAR_iso_checksum "sha256:5e38b55d57d94ff029719342357325ed3bda38fa80054f9330dc789cd2d43931"
ENV PKR_VAR_tmp_directory "/tmp"
ENV PKR_VAR_out_image "ubuntu"
ENV PKR_VAR_out_tag "2204"
ENV PKR_VAR_display "false"
RUN mkdir -p /in /out
WORKDIR /
COPY in/autoinstall /in/autoinstall
COPY image.pkr.hcl /
ENTRYPOINT [ "/usr/bin/packer", "build", "--force", "." ]
