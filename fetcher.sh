#!/bin/bash 
mkdir -p /staging/root
mkdir -p /staging/status

apt update
apt install --no-install-suggests --no-install-recommends --yes --download-only $@

for file in "$(ls /var/cache/apt/archives/*.deb)"; do
    pkg=${file%.deb}
    dpkg-deb -R $pkg*.deb /tmp/$pkg
    cp /tmp/$pkg/DEBIAN/control /staging/status/$pkg
    rm -r /tmp/$pkg/DEBIAN
    cp -r /tmp/$pkg/* /staging/root
    rm -rf /tmp/$pkg
done

apt clean