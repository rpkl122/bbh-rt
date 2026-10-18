#!/bin/sh
MY=$$
for p in $(ps -eo pid,comm 2>/dev/null | grep -iE "exploit" | awk '{print $1}'); do
  [ "$p" != "$MY" ] && kill -9 "$p" 2>/dev/null && echo "killed $p"
done
sleep 2
python3 -c "import ctypes;l=ctypes.CDLL(None);[l.syscall(250,7,ctypes.c_ulong(r)) for r in (-2,-3,-4,-5,-6,-7)]" 2>/dev/null
sleep 1
echo "key-users: $(grep '^ *26:' /proc/key-users)"
python3 -c "
import ctypes
l=ctypes.CDLL(None, use_errno=True)
buf=ctypes.create_string_buffer(b'x'*1001)
k=l.syscall(248, b'user', b'bbh_pk', buf, 1001, -2)
print('add_key rc=',k,'errno=',ctypes.get_errno())
"
