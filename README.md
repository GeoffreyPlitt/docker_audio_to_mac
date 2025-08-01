# docker_audio_to_mac

This repository demonstrates streaming audio from a Docker container to a Mac host using `JACK` audio server in the container, `sox` on Mac, and a `socat` UDP network stream inbetween.

## Quick Start

1. **Install honcho** (process manager):
   ```bash
   pip install honcho
   ```

2. **Run the complete audio pipeline**:
   ```bash
   honcho start
   ```

This will automatically:
- Set up Mac dependencies (sox, socat)
- Start the Docker container that generates and streams audio
- Start the Mac receiver that plays the audio

## Individual Components

You can also run components separately:

```bash
# Start Docker container that streams audio
./run_sender.sh

# Start Mac receiver that plays audio
./run_receiver.sh

# Run arbitrary commands in the container
./run_docker.sh <command>
```

## Architecture

The system uses a client-server architecture:

1. **Server (Docker Container)**:
   - Runs JACK audio server in dummy mode
   - Plays test.mp3 using mpg123 through JACK
   - Captures audio from JACK monitor ports
   - Streams raw audio over UDP port 8000

2. **Client (Mac Host)**:
   - Receives UDP audio stream
   - Converts raw audio to playable format
   - Plays through Mac speakers

### Audio Pipeline
```
MP3 → mpg123 → JACK → jack_capture → socat → UDP:8000 → Mac → play
```

## Requirements

- Docker
- Python with pip (for honcho)
- Homebrew (automatically installs sox and socat)
