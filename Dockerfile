FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN echo "deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware" > /etc/apt/sources.list && \
    echo "deb http://deb.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
    echo "deb http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list

RUN apt update && apt install -y \
    curl ca-certificates gnupg iproute2 git neofetch \
    ffmpeg python3 python3-pip python3-venv \
    build-essential gcc g++ make cmake \
    zip unzip bzip2 tar gzip \
    wget jq libsqlite3-dev zlib1g-dev \
    libssl-dev libffi-dev \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_22.x nodistro main" > /etc/apt/sources.list.d/nodesource.list \
    && apt update && apt install -y nodejs \
    && apt clean && rm -rf /var/lib/apt/lists/*

USER root
ENV USER=root HOME=/home/container
WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
