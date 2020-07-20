version: "3.8"

services:

  router_a:
    privileged: true
    build:
      context: .
      dockerfile: router_a.dockerfile
    ports:
      - "60322:22"
    tty: true
    networks:
      default:
        ipv4_address: 172.30.0.131
    hostname: router_A

  router_b:
    privileged: true
    build:
      context: .
      dockerfile: router_b.dockerfile
    ports:
      - "60422:22"
    tty: true
    networks:
      default:
        ipv4_address: 172.30.0.132
    hostname: router_B

  router_c:
    privileged: true
    build:
      context: .
      dockerfile: router_c.dockerfile
    ports:
      - "60522:22"
    tty: true
    networks:
      default:
        ipv4_address: 172.30.0.133
    hostname: router_C

networks:
  default:
    ipam:
      config:
        - subnet: 172.30.0.0/24
