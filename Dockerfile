FROM solita/ubuntu-systemd

RUN apt-get update
RUN apt-get install -y vim \
    openssh-server \
    openssh-client \
    curl \
    iproute2 \
    net-tools \
    software-properties-common \
    apt-transport-https

RUN mkdir /var/run/sshd

RUN echo 'root:root' | chpasswd

RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

EXPOSE 22
EXPOSE 9999
EXPOSE 9998
EXPOSE 80
EXPOSE 4646
EXPOSE 4647
EXPOSE 4648
EXPOSE 3000
EXPOSE 8300
EXPOSE 8301
EXPOSE 8302
EXPOSE 8400
EXPOSE 8500
