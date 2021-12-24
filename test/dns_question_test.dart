import 'package:dart2.dns/dns.dart';
import 'package:test/test.dart';
import 'dart:typed_data' show Uint8List;

void main() {
  group('DNSQuestion', () {
    setUp(() {});

    test('DNSQuestion.encode()', () {
      var buffer = DNSQuestion.encode(DNSQuestion()..url = 'github.com');
      expect(buffer.toString(), '0667697468756203636f6d0000010001');
    });
  });
}
