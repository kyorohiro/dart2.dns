import 'dart:typed_data';

import 'package:dart2.dns/dns.dart';

void setInt16AtBigEndian(Uint8List buffer, int index, int value) {
  buffer[index + 0] = (value << 8) & 0xFF;
  buffer[index + 1] = (value << 0) & 0xFF;
}

void setByteAtBigEndian(Uint8List buffer, int index, int value) {
  buffer[index] = (value << 0) & 0xFF;
}

void setInt32AtBigEndian(Uint8List buffer, int index, int value) {
  buffer[index + 0] = (value << 24) & 0xFF;
  buffer[index + 1] = (value << 16) & 0xFF;
  buffer[index + 2] = (value << 8) & 0xFF;
  buffer[index + 3] = (value << 0) & 0xFF;
}

printAtHex(Uint8List buffer, int index, int length) {
  StringBuffer b = new StringBuffer();
  const List<String> vv = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'];
  for (int i = index; i < length; i++) {
    int v = buffer[i];
    int v1 = (v >> 4) & 0xF;
    int v2 = v & 0xF;
    b.write('${vv[v1]}${vv[v2]}');
  }
  print('\r\n');
  print('--------');
  print('\r\n');
  print(b.toString());
  print('\r\n');
  print('--------');
  print('\r\n');
}

void main() {
  Uint8List buffer = new Uint8List(54);
  setInt16AtBigEndian(buffer, 0, 123);
  printAtHex(buffer, 0, buffer.length);
}
//007b0100000100000000000005716969746103636f6d0000010001
