FROM jrei/systemd-fedora:latest

RUN dnf update -y \
    dnf install -y git bash procps-ng iptables-nft ipset iproute curl

RUN git clone https://github.com/Snowy-Fluffy/zapret.installer.git /opt/zapret.installer

RUN chmod +x /opt/zapret.installer/zapret-control.sh
