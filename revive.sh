#!/bin/sh
echo "=== before ==="; grep "^ *26:" /proc/key-users
# kill ALL race/exploit procs for uid26 (excluding self)
MY=$$
for p in $(ls /proc 2>/dev/null | grep -E '^[0-9]+$'); do
  [ "$p" = "$MY" ] && continue
  c=$(tr '\0' ' ' < /proc/$p/cmdline 2>/dev/null)
  case "$c" in *race.sh*|*exploit*|*/tmp/rt/e_*|*e_def*|*e_wide*|*e_ms*) 
    u=$(awk '/^Uid:/{print $2}' /proc/$p/status 2>/dev/null)
    [ "$u" = "26" ] && kill -9 "$p" 2>/dev/null && echo "killed $p: $c";; esac
done
sleep 2
python3 -c "import ctypes;l=ctypes.CDLL(None);[l.syscall(250,7,ctypes.c_ulong(r)) for r in range(-1,-10,-1)]" 2>/dev/null
sleep 1
echo "=== after ==="; grep "^ *26:" /proc/key-users
python3 -c "
import ctypes
l=ctypes.CDLL(None,use_errno=True)
buf=ctypes.create_string_buffer(b'x'*1001)
print('add_key rc=',l.syscall(248,b'user',b'rv',buf,1001,-2),'errno=',ctypes.get_errno())
"
