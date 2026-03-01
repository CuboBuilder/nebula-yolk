FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN rm -rf /etc/apt/sources.list.d/* && \
    echo "deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware" > /etc/apt/sources.list && \
    echo "deb http://deb.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
    echo "deb http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list

RUN apt update && apt install -y \
    curl ca-certificates gnupg iproute2 git \
    ffmpeg python3 python3-pip python3-venv \
    build-essential gcc g++ make cmake \
    zip unzip bzip2 tar gzip \
    wget jq libsqlite3-dev zlib1g-dev \
    libssl-dev libffi-dev \
    tmux procps \
    htop nano neofetch \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_22.x nodistro main" > /etc/apt/sources.list.d/nodesource.list \
    && apt update && apt install -y nodejs \
    && apt clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor -o /etc/apt/keyrings/adoptium.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/adoptium.gpg] https://packages.adoptium.net/artifactory/deb $(. /etc/os-release && echo $VERSION_CODENAME) main" > /etc/apt/sources.list.d/adoptium.list \
    && apt update && apt install -y temurin-8-jre temurin-17-jre temurin-21-jre \
    && update-alternatives --install /usr/bin/java java /usr/lib/jvm/temurin-8-jre-amd64/bin/java 80 \
    && update-alternatives --install /usr/bin/java java /usr/lib/jvm/temurin-17-jre-amd64/bin/java 170 \
    && update-alternatives --install /usr/bin/java java /usr/lib/jvm/temurin-21-jre-amd64/bin/java 210 \
    && update-alternatives --set java /usr/lib/jvm/temurin-21-jre-amd64/bin/java \
    && apt clean && rm -rf /var/lib/apt/lists/*

RUN echo 'alias java8="/usr/lib/jvm/temurin-8-jre-amd64/bin/java"' >> /etc/bash.bashrc && \
    echo 'alias java17="/usr/lib/jvm/temurin-17-jre-amd64/bin/java"' >> /etc/bash.bashrc && \
    echo 'alias java21="/usr/lib/jvm/temurin-21-jre-amd64/bin/java"' >> /etc/bash.bashrc && \
    echo 'alias java="java21"' >> /etc/bash.bashrc

RUN useradd -m -d /home/container -u 999 -s /bin/bash container

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh
USER root
RUN chmod +x /entrypoint.sh
USER container

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
