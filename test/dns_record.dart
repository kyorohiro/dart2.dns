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
      print(record.item1[0].name); // c00c
      print(record.item1[0].type); // 0c00 --> 3072 : 0001
      print(record.item1[0].clazz); // 0100 :  0001
      print(record.item1[0].ttl); // 0100000 : 0000003c
      print(record.item1[0].rdlength); // 03c0 // 0004
      print(record.item1[0].rdata); // 0043445ba2c //  3445ba2c

      //expect(record.item1[0]., 'github.com');
      //expect(record.item1[0].qClass, 1);
      //expect(record.item1[0].qType, 1);
    });
  });
}
