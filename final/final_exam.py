#!/usr/bin/env python3


# Example usage:
#   ./final_exam.py

import ctypes
import random
import socket
import struct
import sys

def main():
    server_ip = "10.10.4.50"
    port = 3456
    server_address = (server_ip, port)
    
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    
    A=8
    B=3
    
    raw_byte = bytearray()
    
    raw_byte +=struct.pack("B", 1)
    raw_byte +=struct.pack("!L", A)
    raw_byte +=struct.pack("!L", B)
    raw_byte +=struct.pack("!L", 5)
    raw_byte +=bytes('Sloan','ascii')

    s.sendto(raw_byte, server_address)
    
    (code1, (code2_1, code2_2)) = s.recvfrom(3000)

    s.close()
    
    #print(code1)
    #print(len(code1))
    
    (protocol, code, sumInt) = struct.unpack(">BHI", code1)
    
    #print("protocol: "+str(protocol))
    
    if(code==1):
    	print("Success")
    else:
    	print("Failure")
    
    
    print(str(A)+"+"+str(B)+"="+str(sumInt))
    
    
if __name__ == "__main__":
    sys.exit(main())
