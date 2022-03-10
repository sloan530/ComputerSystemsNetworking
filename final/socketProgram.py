#!/usr/bin/env python3


# Example usage:
#   ./socketProgram.py --server=8.8.8.8


import argparse
import ctypes
import random
import socket
import struct
import sys

def main():

    # Setup configuration
    parser = argparse.ArgumentParser(description='mock exam ECPE 170')
    parser.add_argument('--server', action='store', dest='server_ip',
                        required=True, help='server IP')

    args = parser.parse_args()
    server_ip = args.server_ip
    
    server_address = (server_ip, 3456)

    # Create UDP socket
   
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    except socket.error as msg:
        print("Error: could not create socket")
        print("Description: " + str(msg))
        sys.exit()

    print("Created a socket")
    
    #create message
    
    raw_byte = bytearray()
    
    raw_byte += struct.pack("B",ord('A'))
    raw_byte += struct.pack("!B", 2)
    raw_byte += struct.pack("B", 5)
    raw_byte += bytes('Sloan', 'ascii')
    raw_byte += struct.pack("B",ord('S'))
    raw_byte += struct.pack("B", ord('K'))

    # Send request message to server
    # (Tip: Use sendto() function for UDP)
    
    s.sendto(raw_byte, server_address)
    
    # Receive message from server
    # (Tip: use recvfrom() function for UDP)
    
    raw_bytes = s.recvfrom(1000)
    
    string_unicode = struct.unpack(raw_bytes)
    print(string_unicode)
    
    # Close socket
    s.close()
    

if __name__ == "__main__":
    sys.exit(main())
