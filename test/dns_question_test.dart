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

    ///
    /// 1: 06
    /// 2: 67
    /// 3: 69
    /// 4: 74
    /// 5: 68
    /// 6: 75
    /// 7: 62
    /// 8: 03
    /// 9: 63
    /// 10: 6f
    /// 11: 6d
    /// 12: 00
    /// 13: 00
    /// 14: 01
    /// 15: 00
    /// 16: 01
    ///

    test('DNSQuestion.decode() 1', () {
      var buffer1 = DNSQuestion.encode(DNSQuestion()..hostOrIP = 'github.com');
      var buffer2 = DNSQuestion.encode(DNSQuestion()..hostOrIP = 'yahoo.co.jp');
      var buffer = Buffer.combine([buffer1, buffer2]);
      expect(buffer.toString(), '0667697468756203636f6d0000010001057961686f6f02636f026a700000010001');

      var question = DNSQuestion.decode(buffer, 2);
      expect(question.item1[0].hostOrIP, 'github.com');
      expect(question.item1[1].hostOrIP, 'yahoo.co.jp');
    });

    // var buffer = DNSQuestion.encode(DNSQuestion()..hostOrIP = 'github.com')
    //0667697468756203636f6d0000010001
    //057961686f6f02636f026a700000010001
  });
}
