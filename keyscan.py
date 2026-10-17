import ctypes, struct
l=ctypes.CDLL(None, use_errno=True)
def kc(cmd,*a):
    ctypes.set_errno(0); return l.syscall(250, cmd, *[ctypes.c_ulong(x) for x in a]), ctypes.get_errno()
# try many keyring specs
for spec in range(-9, 0):
    serial,_=kc(0, spec, 0)   # GET_KEYRING_ID
    if serial<0: 
        print("spec",spec,"-> none", serial); continue
    buf=ctypes.create_string_buffer(16384)
    ctypes.set_errno(0); n=l.syscall(250, 11, ctypes.c_ulong(serial), buf, 16384)
    cnt = n//4 if n>0 else 0
    print("spec",spec,"serial",serial,"keys",cnt)
    if cnt>0:
        serials=struct.unpack("<%dI"%cnt, buf.raw[:n])
        for s in serials:
            kc(3,s); kc(9,s,serial)
