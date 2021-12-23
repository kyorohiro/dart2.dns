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

```

### CLIENT REQUEST

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
```



# REF
- DNS Queries over HTTPS (DoH) 
https://datatracker.ietf.org/doc/html/rfc8484

- DOMAIN NAMES - IMPLEMENTATION AND SPECIFICATION 
https://datatracker.ietf.org/doc/html/rfc1035

