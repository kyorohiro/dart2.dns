import 'package:info.kyorohiro.dns/dns.dart';
import 'package:test/test.dart';

void main() {
  group('DNSBuffer', () {
    setUp(() {});

    test('DNSBuffer.decode() 16', () {
      var src = 0x1234;
      var buffer = DNSBuffer(2)..setInt16AtBE(0, src);
      expect(buffer.toString(), '1234');
      var out = buffer.getInt16AtBE(0);
      expect(out, src);
    });
    test('DNSBuffer.decode() 32', () {
      var src = 0x12345678;
      var buffer = DNSBuffer(4)..setInt32AtBE(0, src);
      expect(buffer.toString(), '12345678');
      var out = buffer.getInt32AtBE(0);
      expect(out, src);
    });
    test('DNSBuffer.decode() 32', () {
      var src = '0123456789abcdef';
      var exp = [0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef];
      var buffer = DNSBuffer.fromHexString(src);
      expect(buffer.toString(), src);
    });
    // 0034818000010001000000000667697468756203636f6d0000010001c00c000100010000003c00043445ba2c
  });
}
