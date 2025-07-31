receiver: socat -v -v -b 192 UDP-RECVFROM:8000,reuseaddr - | play -t raw -r 48000 -e signed -b 16 -c 2 -
sender: docker build -t jack-repro . && docker run --rm -v $(pwd):/audio jack-repro