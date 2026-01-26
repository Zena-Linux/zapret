FROM quay.io/fedora/fedora-minimal:latest

RUN echo "max_parallel_downloads=10" >> /etc/dnf/dnf.conf
RUN echo "fastestmirror=True" >> /etc/dnf/dnf.conf

RUN dnf -y --setopt=install_weak_deps=False --nodocs update && \
    dnf -y --nodocs install \
        @virtualization \
        virt-install \
        bridge-utils \
        qemu-device-display-virtio-gpu-gl \
        virglrenderer \
        mesa-libGL \
        mesa-dri-drivers && \
    dnf clean all && rm -rf /var/cache/dnf

RUN mkdir -p /etc/libvirt && \
    printf '%s\n' \
        'unix_sock_group = "libvirt"' \
        'unix_sock_rw_perms = "0770"' \
        'auth_unix_rw = "none"' \
    > /etc/libvirt/libvirtd.conf

RUN mkdir -p /etc/systemd/system/virtqemud.socket.d && \
    printf '%s\n' \
        '[Socket]' \
        'SocketGroup=libvirt' \
        'SocketMode=0770' \
    > /etc/systemd/system/virtqemud.socket.d/override.conf

RUN systemctl enable virtqemud.socket \
    virtnetworkd.socket \
    virtstoraged.socket \
    virtnodedevd.socket
