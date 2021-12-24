import 'package:dart2.dns/dns.dart';
import 'package:test/test.dart';
import 'dart:typed_data' show Uint8List;

void main() {
  group('DNSHeader', () {
    setUp(() {});

    test('DNSheader.encode()', () {
      var buffer = DNSHeader.encode(DNSHeader()..id = 0x7b);
      expect(buffer.toString(), '007b01000001000000000000');
    });
    test('DNSheader.decode()', () {
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

    // 0034818000010001000000000667697468756203636f6d0000010001c00c000100010000003c00043445ba2c
  });
}
