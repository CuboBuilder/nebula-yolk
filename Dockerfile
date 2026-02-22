FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y curl ca-certificates gnupg sudo iproute2 git ffmpeg python3 python3-pip python3-venv \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_22.x nodistro main" > /etc/apt/sources.list.d/nodesource.list \
    && apt update && apt install -y nodejs \
    && useradd -m -d /home/container -u 999 -s /bin/bash container \
    && echo "container ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && apt clean && rm -rf /var/lib/apt/lists/*

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

COPY --chown=container:container ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
