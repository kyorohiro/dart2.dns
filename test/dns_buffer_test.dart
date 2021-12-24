import 'package:dart2.dns/dns.dart';
import 'package:test/test.dart';

void main() {
  group('DNSBuffer', () {
    setUp(() {});

    test('DNSBuffer.decode()', () {
      var src = 0x1234;
      var buffer = Buffer(2)..setInt16AtBigEndian(0, src);
      print(buffer.toString());
      var out = buffer.getInt16FromBigEndian(0);
      expect(out, src);
    });
    // 0034818000010001000000000667697468756203636f6d0000010001c00c000100010000003c00043445ba2c
  });
}
