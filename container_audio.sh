#!/bin/bash

set -ex

jackd -d dummy --monitor -r 48000 -p 256 &
JACK_PID=$!
echo "JACK PID: $JACK_PID"

sleep 3

mpg123 -o jack --loop -1 /audio/test.mp3 &
PLAYBACK_PID=$!
echo "Playback PID: $PLAYBACK_PID"

sleep 3

jack_lsp -c

jack_capture -c 2 -f s16 --port system:monitor_1 --port system:monitor_2 --stdout --no-header | \
socat -d -d -v -v -b 192 - UDP:host.docker.internal:8000,sndbuf=384

kill $PLAYBACK_PID $JACK_PID 2>/dev/null || echo "Process cleanup completed"