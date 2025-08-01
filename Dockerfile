FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    jackd2 \
    jack-stdio \
    jack-tools \
    socat \
    mpg123 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /audio

COPY container_audio.sh .
RUN chmod +x container_audio.sh

CMD ["./container_audio.sh"]