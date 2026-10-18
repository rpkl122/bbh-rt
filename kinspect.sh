#!/bin/sh
echo "=== /proc/keys (uid26) ==="
head -40 /proc/keys 2>&1
echo "=== /proc/key-users ==="
cat /proc/key-users 2>&1
echo "=== sysctl keys ==="
sysctl kernel.keys.maxbytes kernel.keys.maxkeys 2>&1
echo "=== can we read the root keyring serial? ==="
python3 -c "
import ctypes,struct
l=ctypes.CDLL(None,use_errno=True)
# KEYCTL_GET_KEYRING_ID with KEY_SPEC_THREAD=-1, PROCESS=-2, SESSION=-3, USER=-4, USER_SESSION=-5
for spec,name in [(-1,'THREAD'),(-2,'PROCESS'),(-3,'SESSION'),(-4,'USER'),(-5,'USER_SESSION'),(-6,'GROUP'),(-7,'REQKEY_AUTH')]:
    ctypes.set_errno(0); s=l.syscall(250,0,ctypes.c_ulong(spec),ctypes.c_ulong(0))
    print(name, spec, 'serial=',s,'errno=',ctypes.get_errno())
"
