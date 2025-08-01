#!/bin/bash

set -ex

jackd -d dummy --monitor -r 48000 -p 256 &
JACK_PID=$!
echo "JACK PID: $JACK_PID"

sleep 3

jack_lsp -c

mpg123 -o jack -b 1024 -T --no-gapless /audio/test.mp3 &
PLAYBACK_PID=$!
echo "Playback PID: $PLAYBACK_PID"

sleep 1

jack-stdout -b 16 -e signed system:monitor_1 system:monitor_2 | \
socat -d -d -b 192 - UDP:host.docker.internal:8000,sndbuf=384



kill $PLAYBACK_PID $JACK_PID 2>/dev/null || echo "Process cleanup completed"