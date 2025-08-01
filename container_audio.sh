#!/bin/bash

echo "=== Starting JACK audio server ==="
jackd -d dummy --monitor -r 48000 -p 256 &
JACK_PID=$!
echo "JACK PID: $JACK_PID"

sleep 3

echo "=== Checking if JACK is running ==="
if ! kill -0 $JACK_PID 2>/dev/null; then
    echo "ERROR: JACK failed to start!"
    exit 1
fi

echo "=== Starting MP3 playback (looped) ==="
mpg123 -o jack --loop -1 /audio/test.mp3 &
PLAYBACK_PID=$!
echo "Playback PID: $PLAYBACK_PID"

sleep 3

echo "=== Checking JACK connections ==="
jack_lsp -c || echo "jack_lsp failed, continuing anyway"

echo "=== Starting audio capture and streaming for 30 seconds ==="
jack_capture -c 2 -f s16 --port system:monitor_1 --port system:monitor_2 --stdout --no-header --duration 30 | \
socat -d -d -v -v -b 192 - UDP:host.docker.internal:8000,sndbuf=384

echo "=== Cleaning up ==="
kill $PLAYBACK_PID $JACK_PID 2>/dev/null || echo "Process cleanup completed"