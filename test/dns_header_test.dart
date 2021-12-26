import 'package:info.kyorohiro.dns/dns.dart';
import 'package:test/test.dart';
import 'dart:typed_data' show Uint8List;

void main() {
  group('DNSHeader', () {
    setUp(() {});

    test('DNSheader.encode()', () {
      var buffer = DNSHeader.encode(DNSHeader()..id = 0x7b);
      expect(buffer.toString(), '007b01000001000000000000');
    });
    test('DNSheader.decode() 1', () {
      var src = DNSHeader()..id = 0xFEDC;
      var buffer = DNSHeader.encode(src);
      var out = DNSHeader.decode(buffer);
      expect(src.id, out.id);
      expect(src.qr, out.qr);
      expect(src.opcode, out.opcode);
      expect(src.aa, out.aa);
      expect(src.tc, out.tc);
      expect(src.rd, out.rd);
      expect(src.ra, out.ra);
      expect(src.rd, out.rd);
      expect(src.z, out.z);
      expect(src.rcode, out.rcode);
      expect(src.qdcount, out.qdcount);
      expect(src.ancount, out.ancount);
      expect(src.nscount, out.nscount);
      expect(src.arcount, out.arcount);
    });
    test('DNSheader.decode() 2', () {
      var src = DNSHeader()..id = 0xFEDC;
      src.aa = true;
      src.qr = 0x01;
      src.opcode = 0x0E;
      src.aa = true;
      src.tc = false;
      src.rd = true;
      src.ra = false;
      src.z = 0x5;
      src.rcode = 0x2;
      src.qdcount = 0xFFFF;
      src.ancount = 0xFECA;
      src.nscount = 0x1234;
      src.arcount = 0x5432;
      var buffer = DNSHeader.encode(src);
      var out = DNSHeader.decode(buffer);
      expect(src.id, out.id);
      expect(src.qr, out.qr);
      expect(src.opcode, out.opcode);
      expect(src.aa, out.aa);
      expect(src.tc, out.tc);
      expect(src.rd, out.rd);
      expect(src.ra, out.ra);
      expect(src.z, out.z);
      expect(src.rcode, out.rcode);
      expect(src.qdcount, out.qdcount);
      expect(src.ancount, out.ancount);
      expect(src.nscount, out.nscount);
      expect(src.arcount, out.arcount);
    });
    // 0034818000010001000000000667697468756203636f6d0000010001c00c000100010000003c00043445ba2c
  });
}
