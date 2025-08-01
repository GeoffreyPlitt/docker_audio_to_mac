# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose
This repository demonstrates streaming audio from a Docker container to a Mac host using JACK audio server and UDP networking. It proves a minimal reproduction setup for containerized audio processing.

## Commands

### Running the Project
```bash
# One-time Mac setup (installs sox and socat)
./mac_setup.sh

# Start audio streaming (runs both sender and receiver)
honcho start

# Or run individually:
./run_sender.sh    # Start Docker container that streams audio
./run_receiver.sh  # Start Mac receiver that plays audio
```

### Development Commands
```bash
# Build Docker image
docker build --tag jack-repro .

# Run command in container
./run_docker.sh <command>
```

## Architecture

The project uses a client-server architecture:

1. **Server (Docker Container)**:
   - Runs JACK audio server in dummy mode
   - Plays test.mp3 using mpg123 through JACK
   - Captures audio from JACK monitor ports using jack_capture
   - Streams raw audio over UDP using socat

2. **Client (Mac Host)**:
   - Receives UDP audio stream on port 8000
   - Converts raw audio to WAV format
   - Plays through Mac speakers using play (sox)

### Audio Pipeline
```
MP3 → mpg123 → JACK → monitor ports → jack_capture → socat → UDP:8000 → Mac → play
```

### Key Configuration
- **Audio Format**: 48kHz, 16-bit signed, 2 channels (stereo)
- **Network**: UDP port 8000
- **Docker**: Runs with privileged mode and IPC_LOCK capability for real-time audio

## Important Files
- `docker_config.sh`: Centralized Docker configuration
- `container_audio.sh`: Script that runs inside container to generate and stream audio
- `run_sender.sh`: Wrapper that starts the audio streaming container
- `run_receiver.sh`: Mac-side receiver that plays incoming audio