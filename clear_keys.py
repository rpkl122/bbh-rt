import ctypes, struct
l=ctypes.CDLL(None, use_errno=True)
def kc(cmd,*a): 
    ctypes.set_errno(0); return l.syscall(250, cmd, *[ctypes.c_ulong(x) for x in a]), ctypes.get_errno()
# get user keyring serial
uk,_=kc(0, -4, 0)
print("user keyring:", uk)
buf=ctypes.create_string_buffer(16384)
ctypes.set_errno(0); n=l.syscall(250, 11, ctypes.c_ulong(uk), buf, 16384)
print("read rc", n, "errno", ctypes.get_errno())
if n>0:
    serials=struct.unpack("<%dI"%(n//4), buf.raw[:n])
    print("serials:", serials)
    for s in serials:
        kc(3, s)          # REVOKE
        kc(9, s, uk)      # UNLINK
# also clear session (-3) and process (-2)
for r in (-2,-3,-4,-5):
    print("clear", r, kc(7, r))
