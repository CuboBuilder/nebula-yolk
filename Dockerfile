FROM debian:bookworm-slim

RUN apt update && apt install -y sudo curl ca-certificates iproute2 \
    && useradd -m -d /home/container -s /bin/bash container \
    && echo "container ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]
