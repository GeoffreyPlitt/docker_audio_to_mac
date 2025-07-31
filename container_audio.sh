#!/bin/bash

echo "Starting JACK audio server..."
jackd -d dummy -r 48000 -p 512 --monitor &
JACK_PID=$!

sleep 2

echo "Starting MP3 playback..."
mpg123 -j /audio/test.mp3 &
PLAYBACK_PID=$!

sleep 1

echo "Starting audio capture and streaming..."
jack_capture -c 2 -f s16 --port system:monitor_* --stdout --no-header | \
socat -v -v -b 192 - UDP-DATAGRAM:host.docker.internal:8000,sndbuf=384

kill $PLAYBACK_PID $JACK_PID 2>/dev/null