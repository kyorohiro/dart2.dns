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
      var src = '003481800001000100000000';
      var buffer = DNSHeader.encode(DNSHeader()..id = 0x7b);
      expect(buffer.toString(), '007b01000001000000000000');
    });
    // 0034818000010001000000000667697468756203636f6d0000010001c00c000100010000003c00043445ba2c
  });
}
