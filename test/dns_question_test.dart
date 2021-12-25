import 'package:dart2.dns/dns.dart';
import 'package:test/test.dart';
import 'dart:typed_data' show Uint8List;

void main() {
  group('DNSQuestion', () {
    setUp(() {});

    test('DNSQuestion.encode()', () {
      var buffer = DNSQuestion.encode(DNSQuestion()..hostOrIP = 'github.com');
      expect(buffer.toString(), '0667697468756203636f6d0000010001');
    });

    test('DNSQuestion.decode() 1', () {
      var buffer = Buffer.fromHexString('0667697468756203636f6d0000010001');
      var question = DNSQuestion.decode(buffer, 1);
      expect(question.item1[0].hostOrIP, 'github.com');
      expect(question.item1[0].qClass, 1);
      expect(question.item1[0].qType, 1);
    });

    test('DNSQuestion.decode() 1', () {
      var buffer1 = DNSQuestion.encode(DNSQuestion()..hostOrIP = 'github.com');
      var buffer2 = DNSQuestion.encode(DNSQuestion()..hostOrIP = 'yahoo.co.jp');
      var buffer = Buffer.combine([buffer1, buffer2]);
      expect(buffer.toString(), '0667697468756203636f6d0000010001057961686f6f02636f026a700000010001');

      var question = DNSQuestion.decode(buffer, 2);
      expect(question.item1[0].hostOrIP, 'github.com');
      expect(question.item1[1].hostOrIP, 'yahoo.co.jp');
    });
  });
}
