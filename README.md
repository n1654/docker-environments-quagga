# [Sandbox] QUAGGA LAB

Sandbox environment with Cisco like CLI devices based on quagga software:
  - router_A - (zebra, ospfd, bgpd)
  - router_B - (zebra, ospfd, bgpd)
  - router_C - (zebra, ospfd, bgpd)


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

## router_A configuration

**Login to machine**
username: zebra
password: zebra
```sh
$ ssh zebra@172.20.0.131
```

**Default configuration**
```js
################
```

## router_B configuration

**Login to machine**
username: zebra
password: zebra
```sh
$ ssh zebra@172.20.0.132
```

**Default configuration**
```js
################
```

## router_C configuration

**Login to machine**
username: zebra
password: zebra
```sh
$ ssh zebra@172.20.0.133
```

**Default configuration**
```js
################
```
