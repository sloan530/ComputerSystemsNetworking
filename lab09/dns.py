#!/usr/bin/env python3

# Python DNS query client
#
# Example usage:
#   ./dns.py --type=A --name=www.pacific.edu --server=8.8.8.8
#   ./dns.py --type=AAAA --name=www.google.com --server=8.8.8.8

# Should provide equivalent results to:
#   dig www.pacific.edu A @8.8.8.8 +noedns
#   dig www.google.com AAAA @8.8.8.8 +noedns
#   (note that the +noedns option is used to disable the pseduo-OPT
#    header that dig adds. Our Python DNS client does not need
#    to produce that optional, more modern header)


from dns_tools import dns, dns_header_bitfields # Custom module for boilerplate code

import argparse
import ctypes
import random
import socket
import struct
import sys

def main():

    # Setup configuration
    parser = argparse.ArgumentParser(description='DNS client for ECPE 170')
    parser.add_argument('--type', action='store', dest='qtype',
                        required=True, help='Query Type (A or AAAA)')
    parser.add_argument('--name', action='store', dest='qname',
                        required=True, help='Query Name')
    parser.add_argument('--server', action='store', dest='server_ip',
                        required=True, help='DNS Server IP')

    args = parser.parse_args()
    qtype = args.qtype
    qname = args.qname
    server_ip = args.server_ip
    port = 53
    server_address = (server_ip, port)

    if qtype not in ("A", "AAAA"):
        print("Error: Query Type must be 'A' (IPv4) or 'AAAA' (IPv6)")
        sys.exit()

    # Create UDP socket
    # ---------
    # STUDENT TO-DO
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    except socket.error as msg:
        print("Error: could not create socket")
        print("Description: " + str(msg))
        sys.exit()

    print("Created a socket")
    # ---------


    # Generate DNS request message
    # ---------
    # STUDENT TO-DO
    raw_byte = bytearray()
    
    messageID = struct.pack("!H", random.randint(0,65535))
    header = dns_header_bitfields()
    header.qr = 0
    header.opcode = 0
    header.aa = 0
    header.tc = 0
    header.rd = 1
    header.ra = 0
    header.reserved = 0
    header.rcode = 0
    qdcount = struct.pack("!H", 1)
    ancount = struct.pack("!H", 0)
    nscount = struct.pack("!H", 0)
    arcount = struct.pack("!H", 0)
    
    complete_domain = bytearray()

    domain = qname.split(".")
    for i in domain:
    	complete_domain += struct.pack("!B", len(i))
    	complete_domain += bytes(i, 'ascii')
    	
    complete_domain+=struct.pack("!B", 0)
    
    if qtype == 'A':
    	complete_domain += struct.pack("!H", 1)
    else: 
    	complete_domain += struct.pack("!H", 28)
    	
    complete_domain += struct.pack("!H", 1)
    
    raw_byte += messageID
    raw_byte += bytes(header)
    raw_byte += qdcount
    raw_byte += ancount
    raw_byte += nscount 
    raw_byte += arcount
    raw_byte += complete_domain
    # ---------


    # Send request message to server
    # (Tip: Use sendto() function for UDP)
    # ---------
    # STUDENT TO-DO
    s.sendto(raw_byte, server_address)
    
    # ---------


    # Receive message from server
    # (Tip: use recvfrom() function for UDP)
    # ---------
    # STUDENT TO-DO
    (raw_bytes, src_addr) = s.recvfrom(3000)

    # ---------


    # Close socket
    # ---------
    # STUDENT TO-DO
    s.close()
    # ---------


    # Decode DNS message and display to screen
    print(dns.decode_dns(raw_bytes))
	

if __name__ == "__main__":
    sys.exit(main())
