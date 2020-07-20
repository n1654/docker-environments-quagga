# [Sandbox] QUAGGA LAB

Sandbox environment with Cisco like CLI devices based on quagga software:
  - router_A: 
    - (zebra, ospfd, bgpd)
  - router_B:
    - (zebra, ospfd, bgpd)
  - router_C:
    - (zebra, ospfd, bgpd)


## How to run

```sh
$ git clone https://github.com/n1654/docker-environments-quagga.git
$ cd ./docker-environments-quagga
$ sudo docker-compose up -d
```

## Diagram - network

                           +---------------------+
                           |router_A             |
                           |lo:   192.168.99.1/32|
                           |eth0: 172.20.0.131/24|
                           +----------+----------+
                                      |
    +----------+----------------------+----------------------+----------+
               |                                             |
    +----------+----------+                       +----------+----------+
    |router_B             |                       |router_C             |
    |lo:   192.168.99.2/32|                       |lo:   192.168.99.3/32|
    |eth0: 172.20.0.132/24|                       |eth0: 172.20.0.133/24|
    +---------------------+                       +---------------------+
    
## Diagram - OSPF domain

                               +--------------------------+
                               |router_A                  |
                               |advertise: 192.168.99.1/32|
                               |      +------------+      |
                               |      |172.20.0.131|      |
                               |      |    eth0    |      |
                               +------+------+-----+------+
                                             |               OSPF area 1
                 +---------------------------+-------------------------+
                 |                                                     |
    +------------+-------------+                          +------------+-------------+
    |      |172.20.0.132|      |                          |      |172.20.0.133|      |
    |      |    eth0    |      |                          |      |    eth0    |      |
    |      +------------+      |                          |      +------------+      |
    |router_B                  |                          |router_C                  |
    |advertise: 192.168.99.2/32|                          |advertise: 192.168.99.3/32|
    +--------------------------+                          +--------------------------+
    
## Diagram - BPG peering
                               +--------------------------+
                               |router_A                  |
                               |advertise: 192.168.99.1/32|
                               +--------------------------+
                               |       172.20.0.131       |
                         +-----+           eth0           +-----+
                         |     +--------------------------+     |
                         |                                      |
                         |                                      |
                         |                                      |
                         |               AS 64512               |
                         |                                      |
    +--------------------+-----+                          +-----+--------------------+
    |             |172.20.0.132|                          |172.20.0.133|             |
    |             |    eth0    +--------------------------+    eth0    |             |
    |             +------------+                          +------------+             |
    |router_B                  |                          |router_C                  |
    |advertise: 192.168.99.2/32|                          |advertise: 192.168.99.3/32|
    +--------------------------+                          +--------------------------+

## router_A configuration

**Login to machine**
username: zebra
password: zebra
```sh
$ ssh zebra@172.20.0.131
```

**Default configuration**
```bash
router_A# sh run
Building configuration...

Current configuration:
!
log file /var/log/quagga/zebra.log
!
password zebra
enable password zebra
!
interface eth0
!
interface lo
 ip address 192.168.99.1/32
!
router bgp 64512
 bgp router-id 192.168.99.1
 network 192.168.99.1/32
 neighbor 172.20.0.132 remote-as 64512
 neighbor 172.20.0.133 remote-as 64512
!
 address-family ipv6
 exit-address-family
 exit
!
router ospf
 network 172.20.0.0/24 area 0.0.0.1
 network 192.168.99.1/32 area 0.0.0.1
!
ip forwarding
!
line vty
!
end
```

## router_B configuration

**Login to machine**
username: zebra
password: zebra
```sh
$ ssh zebra@172.20.0.132
```

**Default configuration**
```bash
router_B# sh run
Building configuration...

Current configuration:
!
log file /var/log/quagga/zebra.log
!
password zebra
enable password zebra
!
interface eth0
!
interface lo
 ip address 192.168.99.2/32
!
router bgp 64512
 bgp router-id 192.168.99.2
 network 192.168.99.2/32
 neighbor 172.20.0.131 remote-as 64512
 neighbor 172.20.0.133 remote-as 64512
!
 address-family ipv6
 exit-address-family
 exit
!
router ospf
 network 172.20.0.0/24 area 0.0.0.1
 network 192.168.99.2/32 area 0.0.0.1
!
ip forwarding
!
line vty
!
end
```

## router_C configuration

**Login to machine**
username: zebra
password: zebra
```sh
$ ssh zebra@172.20.0.133
```

**Default configuration**
```bash
router_C# sh run
Building configuration...

Current configuration:
!
log file /var/log/quagga/zebra.log
!
password zebra
enable password zebra
!
interface eth0
!
interface lo
 ip address 192.168.99.3/32
!
router bgp 64512
 bgp router-id 192.168.99.3
 network 192.168.99.3/32
 neighbor 172.20.0.131 remote-as 64512
 neighbor 172.20.0.132 remote-as 64512
!
 address-family ipv6
 exit-address-family
 exit
!
router ospf
 network 172.20.0.0/24 area 0.0.0.1
 network 192.168.99.3/32 area 0.0.0.1
!
ip forwarding
!
line vty
!
end
```
