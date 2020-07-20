FROM alpine:latest

RUN apk add --no-cache openssh quagga iputils

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
RUN adduser zebra -G quagga -s /usr/bin/vtysh -D
RUN echo zebra:zebra | chpasswd

RUN mkdir /var/log/quagga/
RUN chown quagga:quagga /var/log/quagga/

# CONFIGURE ZEBRA
RUN echo -e "!\n\
password zebra\n\
enable password zebra\n\
log file /var/log/quagga/zebra.log\n\
!\n\
interface lo\n\
 ip address 192.168.99.1/32\n\
!" > /etc/quagga/zebra.conf
RUN chown quagga:quagga /etc/quagga/zebra.conf
RUN chmod 640 /etc/quagga/zebra.conf

# CONFIGURE OSPFD
RUN echo -e "!\n\
router ospf\n\
 network 172.30.0.0/24 area 0.0.0.1\n\
 network 192.168.99.1/32 area 0.0.0.1\n\
!"> /etc/quagga/ospfd.conf
RUN chown quagga:quagga /etc/quagga/ospfd.conf
RUN chmod 640 /etc/quagga/ospfd.conf

# CONFIGURE BGPD
RUN echo -e "!\n\
router bgp 64512\n\
 bgp router-id 192.168.99.1\n\
 network 192.168.99.1/32\n\
 neighbor 172.30.0.132 remote-as 64512\n\
 neighbor 172.30.0.133 remote-as 64512\n\
!\n\
 address-family ipv6\n\
 exit-address-family\n\
 exit\n\
!" > /etc/quagga/bgpd.conf
RUN chown quagga:quagga /etc/quagga/bgpd.conf
RUN chmod 640 /etc/quagga/bgpd.conf

# START SCRIPT
RUN echo -e "#!bin/sh\n\
\n\
zebra -d -f /etc/quagga/zebra.conf\n\
ospfd -d\n\
bgpd -d\n\
/usr/sbin/sshd -D" >> /start.sh

RUN chmod +x /start.sh

CMD ["/start.sh"]
