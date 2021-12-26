import 'dart:typed_data' show Buffer;
import 'dart:convert' show ascii;
import 'package:dart2.dns/dns.dart';
import 'dart:typed_data' show Uint8List;

String toHex(Uint8List buffer) {
  const List<String> vv = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'];
  var b = StringBuffer();
  for (var i = 0; i < buffer.length; i++) {
    var v = buffer[i];
    var v1 = (v >> 4) & 0xF;
    var v2 = v & 0xF;
    b.write('${vv[v1]}${vv[v2]}');
  }
  return b.toString();
}

void setInt16AtBE(Uint8List _buffer, int index, int value) {
  _buffer[index + 0] = (value >> 8) & 0xFF;
  _buffer[index + 1] = (value >> 0) & 0xFF;
}

void main() {
  // 123401000001000000000000
  var buffer = Uint8List(12);
  for (var i = 0; i < 12; i++) {
    buffer[i] = 0;
  }
  setInt16AtBE(buffer, 0, 0x1234);
  buffer[2] = 0x01;
  setInt16AtBE(buffer, 5, 0x01);
  print(toHex(buffer));
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

/**
NAME: xxbit
TYPE: 16bit
CLASS: 16bit
TTL: 32bit
RDLENGTH: 16bit
RDATA: xxbit
 */
