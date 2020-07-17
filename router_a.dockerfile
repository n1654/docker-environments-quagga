FROM alpine:latest

RUN apk add --no-cache openssh quagga

# CONFIGURE OPENSSH
RUN echo -e "Port 22\n\
AddressFamily any\n\
ListenAddress 0.0.0.0\n\
PermitRootLogin yes\n\
PasswordAuthentication yes" >> /etc/ssh/sshd_config

RUN echo root:root123 | chpasswd

RUN /usr/bin/ssh-keygen -A
RUN ssh-keygen -t rsa -b 4096 -f  /etc/ssh/ssh_host_key

# CONFIGURE QUAGGA
RUN adduser quagga-admin -G quagga -s /usr/bin/vtysh -D
RUN echo quagga-admin:quagga-admin | chpasswd

RUN mkdir /var/log/quagga/
RUN chown quagga:quagga /var/log/quagga/

RUN echo -e "!\n\
password zebra\n\
enable password zebra\n\
log file /var/log/quagga/zebra.log\n\
!" > /etc/quagga/zebra.conf
RUN chown quagga:quagga /etc/quagga/zebra.conf
RUN chmod 640 /etc/quagga/zebra.conf

# START SCRIPT
RUN echo -e "#!bin/sh\n\
\n\
zebra -d -f /etc/quagga/zebra.conf\n\
/usr/sbin/sshd -D" >> /start.sh

RUN chmod +x /start.sh

CMD ["/start.sh"]
