import 'package:dart2.dns/dns.dart';
import 'package:test/test.dart';
import 'dart:typed_data' show Uint8List;

void main() {
  group('DNSReord', () {
    setUp(() {});

    test('DNSRecord.decode() 1', () {
      // c00c000100010000003c00043445ba2c
      var buffer = Buffer.fromHexString('0667697468756203636f6d0000010001c000000100010000003c00043445ba2c');
      var record = DNSRecord.decode(buffer, 16, 1);
      // c00c000100010000003c00043445ba2c
      expect(record.item1[0].name, 'github.com'); // c00c
      expect(record.item1[0].type, 1); // 0001
      expect(record.item1[0].clazz, 1); // 0001
      expect(record.item1[0].ttl, 60); // 0000003c
      expect(record.item1[0].rdlength, 4); // 0004
      expect(record.item1[0].rdata, <int>[52, 69, 186, 44]); //  3445ba2c
    });
  });
}
