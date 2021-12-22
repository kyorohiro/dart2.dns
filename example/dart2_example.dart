import 'dart:typed_data' show Buffer;

import 'package:dart2.dns/dns.dart';

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

void main() {
  var buffer = DNS().generateAMessage("qiita.com");
  //Buffer buffer = new Buffer(54);
  //buffer.setInt16AtBigEndian(0, 123);
  buffer.printAtHex(0, buffer.raw.length);
}
//007b0100000100000000000005716969746103636f6d0000010001
