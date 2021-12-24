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
  });
}
