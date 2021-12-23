library dart2;

import 'dart:convert' show ascii;
import 'package:dart2.dns/dns.dart';
import 'dart:typed_data' show Uint8List;
import 'package:tuple/tuple.dart' show Tuple2;
export 'src/buffer.dart';

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
  ///   int item is next index
  static Tuple2<String, int> qnameToUrl(Uint8List srcBuffer, int length) {
    return _qnameToUrl(srcBuffer, 0, length);
  }

  ///
  ///
  /// ret
  ///   string item is url
  ///   int item is next index
  static Tuple2<String, int> _qnameToUrl(Uint8List srcBuffer, int index, int length) {
    var outBuffer = StringBuffer();
    if (length > srcBuffer.length) {
      length = srcBuffer.length;
    }
    var i = 0;

    for (i = 0; i < length;) {
      var nameLength = srcBuffer[i];
      if (nameLength == 0) {
        i++;
        break;
      }
      if (i + 1 + nameLength > length) {
        // anything wrong , return empty string
        throw Exception('>>Wrong i+nameLength > length := ${i + nameLength} > $length');
      }

      var nameBytes = srcBuffer.sublist(i + 1, i + 1 + nameLength);
      if (i != 0) {
        outBuffer.write('.');
      }
      outBuffer.write(ascii.decode(nameBytes, allowInvalid: true));
      i = i + 1 + nameLength;
    }
    return Tuple2<String, int>(outBuffer.toString(), i);
  }

  Buffer generateAMessage(String host) {
    Buffer buffer = new Buffer(54);
    // https://datatracker.ietf.org/doc/html/rfc1035
    // DNS_HEADER
    //
    {
      // ID: 16bit
      buffer.setInt16AtBigEndian(0, 123);
    }
    {
      // QR: 1bit
      // OPCODE: 4bit
      // AA: 1bit
      // TC: 1bit
      // RD: 1bit
      int qr = 0; // 1bit  query (0), or a response (1).
      int opcode = DNS.OPCODE_QUERY;
      bool aa = false;
      bool tc = false;
      bool rd = true;
      int tmp = 0x00;
      tmp |= (qr << 7) & 0xFF;
      tmp |= (opcode << 3);
      if (aa) {
        tmp |= (0x01 << 2) & 0xFF;
      }
      if (tc) {
        tmp |= (0x01 << 1) & 0xFF;
      }
      if (rd) {
        tmp |= (0x01 << 0) & 0xFF;
      }
      buffer.setByteAtBigEndian(2, tmp);
    }
    {
      // RA: 1bit
      // Z: 3bit
      // RCODE: 4bit
      bool ra = false;
      int z = 0;
      int rcode = RCODE_NO_ERROR;
      int tmp = 0x00;
      if (ra) {
        tmp |= (0x01 << 7) & 0xFF;
      }
      tmp |= (z << 4) & 0xFF;
      tmp |= (rcode) & 0xFF;

      buffer.setByteAtBigEndian(3, tmp);
    }

    // QDCOUNT: 16bit
    // ANCOUNT: 16bit
    // NSCOUNT: 16bit
    // ARCOUNT: 16bit
    int qdcount = 1;
    int ancount = 0;
    int nscount = 0;
    int arcount = 0;
    buffer.setInt16AtBigEndian(4, qdcount);
    buffer.setInt16AtBigEndian(6, ancount);
    buffer.setInt16AtBigEndian(8, nscount);
    buffer.setInt16AtBigEndian(10, arcount);

    return buffer;
  }
}
