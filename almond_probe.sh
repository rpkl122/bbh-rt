#!/bin/sh
echo "=== avn.* python modules (service agents) ==="
python3 -c "import avn, os; print(sorted(os.listdir(os.path.dirname(avn.__file__))))" 2>&1 | head
echo "=== almond routes/module ==="
python3 -c "import avn.pg_almond as a; print(a.__file__)" 2>&1 | head -2
echo "=== nodecom :13737 HTTP GET (does it answer HTTP?) ==="
C=/run/aiven/service-keys/service-chain-with-key.pem
curl -sk --http1.1 --cert $C --key $C -m 8 -D - -o /dev/null "https://35.210.19.55:13737/" 2>&1 | head -8
echo "--- raw tcp banner ---"
python3 -c "
import socket,ssl
ctx=ssl.create_default_context(); ctx.check_hostname=False; ctx.verify_mode=ssl.CERT_NONE
s=socket.create_connection(('35.210.19.55',13737),timeout=8)
try:
    ss=ctx.wrap_socket(s); ss.sendall(b'GET / HTTP/1.0\r\n\r\n')
    import time; time.sleep(2)
    print('resp:', ss.recv(200))
except Exception as e: print('err', e)
"
