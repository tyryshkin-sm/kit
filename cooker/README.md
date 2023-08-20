# Create image via packer, ansible and qemu

See help below.

## Schema of user-data

[link](https://ubuntu.com/server/docs/install/autoinstall-reference)

## How to generate default user password

echo -n "123456" | openssl passwd -6 -stdin

## How to debug configuration and acceptance tests

1. Нарезать обрраз
`make source.debug`

2. Запустить образ в qemu
`-virtfs local,path=in,mount_tag=host0,security_model=passthrough,id=host0`

3. Смонтировать виртуальную файловую систему в гостевой системе, дописав в /etc/fstab
`host0 /mnt 9p trans=virtio,version=9p2000.L 0 0`

4. `sudo mount -a`

5. Поставить в систему anslbie и pytest
`sudo apt-get install -y python3-pip`
`sudo pip3 install pytest`

6. Отладить конфигурацию и acceptance-тесты
`pytest /mnt/pytest`

7. После отладки собрать образ
`make source.debug`

8. Собрать финальный образ
`make image.build`

## Image build

Можно запустить `make image.build network=host` и подключиться по VNC.

```bash
docker run \
    -it \
    --privileged \
    \
    -e PKR_VAR_iso_url="https://releases.ubuntu.com/22.04.2/ubuntu-22.04.2-live-server-amd64.iso" \
    -e PKR_VAR_iso_checksum="sha256:5e38b55d57d94ff029719342357325ed3bda38fa80054f9330dc789cd2d43931" \
    -e PKR_VAR_tmp_directory="/tmp" \
    -e PKR_VAR_output_image="ubuntu" \
    -e PKR_VAR_output_tag="2204" \
    -e PKR_VAR_display="false" \
    \
    -v ${HOME}/.cache/packer:/cache \
    -v $(shell pwd)/in/autoinstall:/in/autoinstall \
    -v $(shell pwd)/in/ansible:/in/ansible \
    -v $(shell pwd)/in/pytest:/in/pytest \
    -v $(shell pwd)/out:/out \
    \
    --network ${network} \
    ${registry}/cooker:${cooker_version}
```

## Run qemu localy

qemu-system-x86_64 \
    -m 2048 \
    -hda out/ubuntu-2204 \
    -device e1000,netdev=vlan0 \
    -netdev user,id=vlan0,net=192.168.100.0/24,dhcpstart=192.168.100.10,hostfwd=tcp::2222-:22
