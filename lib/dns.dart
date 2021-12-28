library dart2;

import 'package:info.kyorohiro.dns/dns.dart';
export 'src/header.dart';
export 'src/buffer.dart';
export 'src/question.dart';
export 'src/record.dart';
export 'src/name.dart';
export 'src/dict.dart';

class DNSMessage {
  DNSHeader header;
  List<DNSQuestion> question;
  List<DNSRecord> answer;
  List<DNSRecord> authority;
  List<DNSRecord> additional;
}

class DNS {
  static final int OPCODE_QUERY = 0;
  static final int OPCPDE_IQUERY = 1;
  static final int OPCODE_STATUS = 2;

  static final int RCODE_NO_ERROR = 0;
  static final int RCODE_FORMAT_ERROR = 1;
  static final int RCODE_SERVER_FAILURE = 2;
  static final int RCODE_NAME_ERROR = 3;
  static final int RCODE_NOT_IMPLEMENTED = 4;
  static final int RCODE_REFUSED = 5;

  static final int QTYPE_A = 1; // a host address
  static final int QTYPE_NS = 2; // an authoritative name server
  static final int QTYPE_MD = 3; // a mail destination (Obsolete - use MX)
  static final int QTYPE_MF = 4; // a mail forwarder (Obsolete - use MX)
  static final int QTYPE_CNAME = 5; // the canonical name for an alias
  static final int QTYPE_SOA = 6; // marks the start of a zone of authority
  static final int QTYPE_MB = 7; // a mailbox domain name (EXPERIMENTAL)
  static final int QTYPE_MG = 8; // a mail group member (EXPERIMENTAL)
  static final int QTYPE_MR = 9; // a mail rename domain name (EXPERIMENTAL)
  static final int QTYPE_NULL = 10; // a null RR (EXPERIMENTAL)
  static final int QTYPE_WKS = 11; // a well known service description
  static final int QTYPE_PTR = 12; // a domain name pointer
  static final int QTYPE_HINFO = 13; // host information
  static final int QTYPE_MINFO = 14; // mailbox or mail list information
  static final int QTYPE_MX = 15; // mail exchange
  static final int QTYPE_TXT = 16; // text strings

  static final int QCLASS_IN = 1; // the Internet
  static final int QCLASS_CS = 2; // the CSNET class (Obsolete - used only for examples in some obsolete RFCs)
  static final int QCLASS_CH = 3; // the CHAOS class
  static final int QCLASS_HS = 4; // Hesiod [Dyer 87]

  static DNSBuffer generateAMessage(String host, [int id = 0x1234]) {
    var headerBuffer = (DNSHeader()..id = id).generateBuffer();
    var questionBuffer = (DNSQuestion()..qName = host).generateBuffer();
    return DNSBuffer.combine([headerBuffer, questionBuffer]);
  }

  static DNSMessage parseMessage(DNSBuffer dnsBuffer) {
    var header = DNSHeader.decode(dnsBuffer);
    var questionInfo = DNSQuestion.decode(dnsBuffer, DNSHeader.BUFFER_SIZE, header.qdcount);
    var answerInfo = DNSRecord.decode(dnsBuffer, DNSHeader.BUFFER_SIZE + questionInfo.item2, header.ancount);
    var authorityInfo = DNSRecord.decode(dnsBuffer, DNSHeader.BUFFER_SIZE + questionInfo.item2 + answerInfo.item2, header.nscount);
    var additionalInfo = DNSRecord.decode(dnsBuffer, DNSHeader.BUFFER_SIZE + questionInfo.item2 + answerInfo.item2 + authorityInfo.item2, header.arcount);
    return DNSMessage() //
      ..header = header
      ..question = questionInfo.item1 ?? []
      ..answer = answerInfo.item1 ?? []
      ..authority = authorityInfo.item1 ?? []
      ..additional = additionalInfo.item1 ?? [];
  }
}
