import 'dart:typed_data' show Buffer;
import 'dart:convert' show ascii;
import 'package:dart2.dns/dns.dart';
import 'dart:typed_data' show Uint8List;

void main() {
  var buffer = DNS().generateAMessage("github.com");
  //Buffer buffer = new Buffer(54);
  //buffer.setInt16AtBigEndian(0, 123);
  buffer.printAtHex(0, buffer.raw.length);
}
//007b0100000100000000000005716969746103636f6d0000010001
