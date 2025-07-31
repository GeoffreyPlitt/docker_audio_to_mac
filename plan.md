# Jack Audio Capture Network Streaming - Minimal Reproduction

## **Purpose**
This repo proves how to do audio streaming from a Docker container to a Mac host using JACK audio server and UDP networking. The goal is to prove that we can:

1. Generate audio inside a Linux container using JACK
2. Capture that audio with `jack_capture` 
3. Stream it over UDP to the Mac host
4. Play it back on Mac speakers in real-time

## **Repository Structure**
```
jack_capture_repro/
├── Dockerfile
├── Procfile (for Honcho process manager)
├── mac_setup.sh
├── container_audio.sh
├── test.mp3 (user-provided audio file)
└── README.md
```

## **Components**

### **Dockerfile**
- Base: Debian (lightweight Linux)
- Install packages:
  - `jackd2` - JACK audio server
  - `jack-capture` - Tool to capture JACK audio to files/stdout
  - `socat` - Network socket utility for UDP streaming
  - `mpg123` - MP3 player that outputs to JACK

### **mac_setup.sh**
One-time setup script for Mac host:
- Check if Homebrew is installed
- Install `sox` (audio processing) and `socat` (networking) if not present
- Verify installation

### **Procfile (Honcho Configuration)**
Defines two processes that run simultaneously:
```
receiver: socat UDP-RECVFROM:8000,reuseaddr - | play -t raw -r 48000 -e signed -b 16 -c 2 -
sender: docker run --rm -v $(pwd):/audio jack-repro ./container_audio.sh
```
- **receiver**: Mac process that listens on UDP port 8000 and plays incoming audio
- **sender**: Docker container that generates and streams audio

### More useful commands - these may work better, may not.
Container:
jack_capture -c 2 -f s16 --port system:monitor_* --stdout --no-header |
socat -b 192 - UDP-DATAGRAM:host.docker.internal:8000,sndbuf=384

Mac host:
socat -b 192 UDP-RECVFROM:8000,reuseaddr - |
play -t raw -r 48000 -e signed -b 16 -c 2 -


### **container_audio.sh**
Container script that:
1. Starts JACK dummy driver with `--monitor` ports (captures all audio output)
2. Plays the MP3 file through JACK using `mpg123`
3. Uses `jack_capture` to capture audio from JACK monitor ports
4. Pipes captured audio to `socat` for UDP streaming to Mac

**Key pipeline:**
```
MP3 → mpg123 → JACK → monitor ports → jack_capture → socat → UDP → Mac
```

## **Expected Behavior**
- User runs `honcho start`
- Container plays MP3 file
- Audio streams continuously over network
- Mac plays the MP3 audio through speakers
- Process continues until manually stopped

## Also
- Strive for a single docker command that build and runs. Build should be no-op if the layers are cached.