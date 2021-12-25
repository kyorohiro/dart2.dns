import 'dart:typed_data' show Buffer;
import 'dart:convert' show ascii;
import 'package:dart2.dns/dns.dart';
import 'dart:typed_data' show Uint8List;

void main() {
  //var buffer = DNS().generateAMessage("github.com");
  //print(buffer.toBase64());
  var buffer = Buffer.fromHexString('0034818000010001000000000667697468756203636f6d0000010001c00c000100010000003c00043445ba2c');
  var header = DNSHeader.decode(buffer);
  var question = DNSQuestion.decode(buffer.subBuffer(12, -1), header.qdcount);
}
//007b0100000100000000000005716969746103636f6d0000010001

/// 0034
/// 8180
/// 0001
/// 0001
/// 0000
/// 0000
/// 0667697468756203636f6d0000010001
/// c00c000100010000003c00043445ba2c
