#!/bin/bash

set -ex

jackd -d dummy --monitor -r 48000 -p 128 &
JACK_PID=$!
echo "JACK PID: $JACK_PID"

sleep 3

jack_lsp -c

mpg123 -o jack -b 256 -T --no-gapless /audio/test.mp3 &
PLAYBACK_PID=$!
echo "Playback PID: $PLAYBACK_PID"

sleep 1

jack-stdout -b 16 -e signed system:monitor_1 system:monitor_2 | \
socat -d -d -b 128 - UDP:host.docker.internal:8000,sndbuf=256



kill $PLAYBACK_PID $JACK_PID 2>/dev/null || echo "Process cleanup completed"