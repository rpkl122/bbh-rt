#!/bin/sh
echo "=== avn package contents ==="
ls /usr/lib/python3.14/site-packages/avn/ 2>&1
echo "=== any kafka/other *_almond? ==="
ls -d /usr/lib/python3.14/site-packages/avn/*almond* 2>&1
echo "=== nodecom :13737 with node cert (mTLS) ==="
C=/run/aiven/service-keys/service-chain-with-key.pem
python3 - <<'PY'
import socket,ssl,time
ctx=ssl.create_default_context(); ctx.check_hostname=False; ctx.verify_mode=ssl.CERT_NONE
ctx.load_cert_chain('/run/aiven/service-keys/service-chain-with-key.pem')
s=socket.create_connection(('35.210.19.55',13737),timeout=10)
try:
    ss=ctx.wrap_socket(s); print('TLS OK', ss.version())
    ss.sendall(b'GET / HTTP/1.0\r\nHost: x\r\n\r\n'); time.sleep(2)
    print('resp:', ss.recv(300))
except Exception as e: print('err', e)
PY
