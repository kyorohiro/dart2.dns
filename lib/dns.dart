library dart2;

import 'dart:convert' show ascii;
import 'package:dart2.dns/dns.dart';
import 'dart:typed_data' show Uint8List;
import 'package:tuple/tuple.dart' show Tuple2;
import 'dart:math' show Random;
export 'src/buffer.dart';

///
/// https://datatracker.ietf.org/doc/html/rfc1035
///
class DNSHeader {
  //
  int id = 0; // ID: 16bit if 0 generate RandomID
  int qr = 0; // QR: 1bit  query (0), or a response (1).
  int opcode = DNS.OPCODE_QUERY; // OPCODE: 4bit
  bool aa = false; // AA: 1bit
  bool tc = false; // TC: 1bit
  bool rd = true; // RD: 1bit
  bool ra = false; // RA: 1bit
  int z = 0; // Z: 3bit
  int rcode = DNS.RCODE_NO_ERROR; // RCODE: 4bit
  int qdcount = 1; // QDCOUNT: 16bit
  int ancount = 0; // ANCOUNT: 16bit
  int nscount = 0; // NSCOUNT: 16bit
  int arcount = 0; // ARCOUNT: 16bit

  Buffer generateBuffer() {
    return DNSHeader.encode(this);
  }

  static DNSHeader decode(Buffer buffer) {
    var header = DNSHeader();
    header.id = buffer.getInt16FromBigEndian(0);
    {
      var tmp = buffer.getByteFromBigEndian(2);
      header.qr = (tmp >> 7) & 0x01;
      header.opcode = (tmp >> 3) & 0x0F;
      header.aa = ((tmp >> 2) & 0x01) == 1;
      header.tc = ((tmp >> 1) & 0x01) == 1;
      header.rd = ((tmp >> 0) & 0x01) == 1;
    }
    {
      var tmp = buffer.getByteFromBigEndian(3);
      header.ra = ((tmp >> 7) & 0x01) == 1;
      header.z = (tmp >> 4) & 0x07;
      header.rcode = (tmp >> 0) & 0x0F;
    }

    {
      header.qdcount = buffer.getInt16FromBigEndian(4);
      header.ancount = buffer.getInt16FromBigEndian(6);
      header.nscount = buffer.getInt16FromBigEndian(8);
      header.arcount = buffer.getInt16FromBigEndian(10);
    }
    return header;
  }

  static Buffer encode(DNSHeader header) {
    var buffer = Buffer(12);

    ///
    /// HEADER
    ///
    {
      // ID: 16bit
      var id = header.id;
      if (id == 0) {
        id = Random.secure().nextInt(0xFFFF);
      }
      buffer.setInt16AtBigEndian(0, id);
    }
    {
      var tmp = 0x00;
      tmp |= (header.qr << 7) & 0xFF;
      tmp |= (header.opcode << 3);
      if (header.aa) {
        tmp |= (0x01 << 2) & 0xFF;
      }
      if (header.tc) {
        tmp |= (0x01 << 1) & 0xFF;
      }
      if (header.rd) {
        tmp |= (0x01 << 0) & 0xFF;
      }
      buffer.setByteAtBigEndian(2, tmp);
    }
    {
      var tmp = 0x00;
      if (header.ra) {
        tmp |= (0x01 << 7) & 0xFF;
      }
      tmp |= (header.z << 4) & 0xFF;
      tmp |= (header.rcode) & 0xFF;

      buffer.setByteAtBigEndian(3, tmp);
    }

    buffer.setInt16AtBigEndian(4, header.qdcount);
    buffer.setInt16AtBigEndian(6, header.ancount);
    buffer.setInt16AtBigEndian(8, header.nscount);
    buffer.setInt16AtBigEndian(10, header.arcount);
    return buffer;
  }
}

///
///
/// QCLASS: 16bit
class DNSQuestion {
  String hostOrIP = 'github.com'; // QNAME: X bit
  int qType = DNS.QTYPE_A; // QTYPE: 16bit
  int qClass = DNS.QCLASS_IN; // QCLASS: 16bit

  Buffer generateBuffer() {
    return DNSQuestion.encode(this);
  }

  static Buffer encode(DNSQuestion q) {
    var qnameBuffer = DNSName.urlToQname(q.hostOrIP);
    var buffer = Buffer(qnameBuffer.length + 2 + 2);
    buffer.setBytes(0, qnameBuffer);
    buffer.setInt16AtBigEndian(qnameBuffer.length, q.qType);
    buffer.setInt16AtBigEndian(qnameBuffer.length + 2, q.qClass);
    return buffer;
  }
}

class DNSName {
  static Uint8List urlToQname(String url) {
    var urlBytes = ascii.encode(url);
    var buffer = List<int>.empty(growable: true);
    var tmp = List<int>.empty(growable: true);
    var tmpIndex = 0;
    //urlBytes.forEach((c)
    var tmpToBuffer = () {
      if (tmp.isNotEmpty) {
        buffer.add(tmpIndex);
        buffer.addAll(tmp.sublist(0, tmpIndex));
        tmpIndex = 0;
        tmp.clear();
      }
    };
    for (var i = 0; i < urlBytes.length; i++) {
      var c = urlBytes[i];
      if (0x2E == c) {
        tmpToBuffer();
        continue;
      } else {
        tmp.add(c);
        tmpIndex++;
      }
    }
    tmpToBuffer();
    buffer.add(0);
    return Uint8List.fromList(buffer);
  }

  ///
  ///
  /// ret
  ///   string item is url
  ///   int item is next index without Null(0)
  static Tuple2<String, int> qnameToUrl(Uint8List srcBuffer, int index, int length) {
    var outBuffer = StringBuffer();
    if (length > srcBuffer.length) {
      length = srcBuffer.length;
    }
    var i = index;

    for (; i < length;) {
      var nameLength = srcBuffer[i];

      if (nameLength == 0) {
        // if Null(0) is TEXT END
        // i++;
        break;
      } else if ((0xC0 & nameLength) == 0xC0) {
        // compression
        var v = (0x3f & nameLength);
        var r = qnameToUrl(srcBuffer, v, length);
        if (outBuffer.length > 0) {
          outBuffer.write('.');
        }
        outBuffer.write(r.item1);
        i++;
        break;
      } else if (i + 1 + nameLength > length) {
        // anything wrong , return empty string
        throw Exception('>>Wrong i+nameLength > length := ${i + nameLength} > $length');
      } else {
        var nameBytes = srcBuffer.sublist(i + 1, i + 1 + nameLength);
        if (outBuffer.length > 0) {
          outBuffer.write('.');
        }
        outBuffer.write(ascii.decode(nameBytes, allowInvalid: true));
        i = i + 1 + nameLength;
      }
    }
    return Tuple2<String, int>(outBuffer.toString(), i);
  }

  static Tuple2<List<String>, int> qnamesToUrls(Uint8List srcBuffer, int length, int count) {
    int index = 0;
    List<String> qnames = [];
    for (var c = 0; c < count; c++) {
      var r = qnameToUrl(srcBuffer, index, length);
      qnames.add(r.item1);
      index = r.item2;
      if (srcBuffer[index] == 0x00) {
        index++;
      }
    }
    return Tuple2<List<String>, int>(qnames, index);
  }
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

  Buffer generateAMessage(String host, [int id = 0x1234]) {
    var headerBuffer = (DNSHeader()..id = id).generateBuffer();
    var questionBuffer = (DNSQuestion()..hostOrIP = host).generateBuffer();
    return Buffer.combine([headerBuffer, questionBuffer]);
  }
}
