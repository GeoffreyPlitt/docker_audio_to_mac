receiver: socat -d -d -v -v -b 192 UDP-LISTEN:8000,reuseaddr - | play -t raw -r 48000 -e signed -b 16 -c 2 -
sender: ./run_sender.sh