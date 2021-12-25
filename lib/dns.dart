library dart2;

import 'dart:convert' show ascii;
import 'package:dart2.dns/dns.dart';
import 'dart:typed_data' show Uint8List;
import 'package:tuple/tuple.dart' show Tuple2;
export 'src/header.dart';
export 'src/buffer.dart';
export 'src/question.dart';
export 'src/record.dart';

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
  ///   int item is length without Null(0)
  static Tuple2<String, int> qnameToUrl(Uint8List srcBuffer, int index, int length) {
    var outBuffer = StringBuffer();
    if (length > srcBuffer.length) {
      length = srcBuffer.length;
    }
    var i = index;
    for (; i < length;) {
      var nameLength = srcBuffer[i];
      print(">> [${i}] nbs = ${nameLength}");
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
        throw Exception('>> [${i}] Wrong i+nameLength > length := ${i + 1 + nameLength} > $length');
      } else {
        var nameBytes = srcBuffer.sublist(i + 1, i + 1 + nameLength);
        if (outBuffer.length > 0) {
          outBuffer.write('.');
        }
        outBuffer.write(ascii.decode(nameBytes, allowInvalid: true));
        i = i + 1 + nameLength;
      }
    }
    return Tuple2<String, int>(outBuffer.toString(), i - index);
  }

  static Tuple2<List<String>, int> qnamesToUrls(Uint8List srcBuffer, int length, int count) {
    var index = 0;
    var qnames = <String>[];
    for (var c = 0; c < count; c++) {
      var r = qnameToUrl(srcBuffer, index, length);
      qnames.add(r.item1);
      index += r.item2;
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

  Buffer parseMessage(Buffer buffer) {
    var header = DNSHeader.decode(buffer);
    //header.
  }
}
