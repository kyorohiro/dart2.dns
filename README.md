Hello DNS Query

# QUERY FORMAT

```
HEADER: (OPCODE=RESPONSE, ID=997 )
QUESTION: (QTYPE=A, QCLASS=IN, QNAME=VENERA.ISI.EDU)
ANSWER: (VENERA.ISI.EDU  A IN 10.1.0.52)
AUTHORITY:  (<empty>)
ADDITIONAL: (<empty>)
```

# HEADER
```
ID:16bit,
QR:1bit, OPCODE:4bit, AA:1bit, TC:1bit, RD:1bit,
RA:1bit, Z:3bit, RCODE: 4bit
QDCOUNT:16bit,
ANCOUNT:16bit,
NSCOUNT:16bit,
ARCOUNT:16bit
```

# QUESTION
```
QNAME: X bit // 
QTYPE: 16bit
QCLASS: 16bit
```

# QTYPE

```
TYPE            value and meaning
A               1 a host address
NS              2 an authoritative name server
MD              3 a mail destination (Obsolete - use MX)
MF              4 a mail forwarder (Obsolete - use MX)
CNAME           5 the canonical name for an alias
SOA             6 marks the start of a zone of authority
MB              7 a mailbox domain name (EXPERIMENTAL)
MG              8 a mail group member (EXPERIMENTAL)
MR              9 a mail rename domain name (EXPERIMENTAL)
NULL            10 a null RR (EXPERIMENTAL)
WKS             11 a well known service description
PTR             12 a domain name pointer
HINFO           13 host information
MINFO           14 mailbox or mail list information
MX              15 mail exchange
TXT             16 text strings
```

# QCLASS

```
IN              1 the Internet
CS              2 the CSNET class (Obsolete - used only for examples in
                some obsolete RFCs)
CH              3 the CHAOS class
HS              4 Hesiod [Dyer 87]
```

### CLIENT REQUEST SAMPLE

```
ID:16bit // client generate id 
QR:1bit, // QUERY(0) 
OPCODE:4bit // Standart Query(0)
AA:1bit // 0 This Params is for Response
TC:1bit // 0 This Params is for Response
RD:1bit // Recursion Desired(1) 
RA:1bit // 0 This Params is for Response
Z:3bit // 0 Reseved params for furture 
RCODE: 4bit // 0 This Params is for Response
QDCOUNT:16bit // 1 or number of questions
ANCOUNT:16bit //  0 This Params is for Response
NSCOUNT:16bit //  0 This Params is for Response
ARCOUNT:16bit //  0 This Params is for Response
QNAME: X bit // 
QTYPE: 16bit
QCLASS: 16bit
```

### SERVER RESPONSE SAMPLE

```
ID:16bit // client generate id 
QR:1bit, // QUERY(0) 
OPCODE:4bit // Standart Query(0)
AA:1bit // 0 This Params is for Response
TC:1bit // 0 This Params is for Response
RD:1bit // Recursion Desired(1) 
RA:1bit // 0 This Params is for Response
Z:3bit // 0 Reseved params for furture 
RCODE: 4bit // 0 This Params is for Response
QDCOUNT:16bit // 1 or number of questions
ANCOUNT:16bit //  0 This Params is for Response
NSCOUNT:16bit //  0 This Params is for Response
ARCOUNT:16bit //  0 This Params is for Response
QNAME: X bit // 
QTYPE: 16bit
QCLASS: 16bit
```

# REF
- DNS Queries over HTTPS (DoH) 
https://datatracker.ietf.org/doc/html/rfc8484

- DOMAIN NAMES - IMPLEMENTATION AND SPECIFICATION 
https://datatracker.ietf.org/doc/html/rfc1035

