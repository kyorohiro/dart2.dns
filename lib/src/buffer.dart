import 'dart:typed_data';

class Buffer {
  Uint8List _buffer;
  Uint8List get raw => _buffer;

  static final List<String> vv = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'];

  static Buffer combine(List<Buffer> buffers) {
    var length = 0;
    buffers.forEach((b) {
      length += b.raw.length;
    });
    var buffer = Buffer(length);
    var index = 0;
    buffers.forEach((b) {
      buffer.setBytes(index, b.raw);
      index += b.raw.length;
    });
    return buffer;
  }

  Buffer.fromList(List<int> buffer) {
    Uint8List.fromList(buffer);
  }

  Buffer(int length) {
    _buffer = Uint8List(length);

    // ZERO CLEAR
    for (var i = 0; i < length; i++) {
      _buffer[i] = 0;
    }
  }

  void setInt16AtBigEndian(int index, int value) {
    _buffer[index + 0] = (value << 8) & 0xFF;
    _buffer[index + 1] = (value << 0) & 0xFF;
  }

  void setByteAtBigEndian(int index, int value) {
    _buffer[index] = (value << 0) & 0xFF;
  }

  void setInt32AtBigEndian(int index, int value) {
    _buffer[index + 0] = (value << 24) & 0xFF;
    _buffer[index + 1] = (value << 16) & 0xFF;
    _buffer[index + 2] = (value << 8) & 0xFF;
    _buffer[index + 3] = (value << 0) & 0xFF;
  }

  void setBytes(int index, List<int> bytes) {
    _buffer.setRange(index, index + bytes.length, bytes);
  }

  printAtHex() {
    print(toString());
  }

  String toString() {
    var b = StringBuffer();
    for (var i = 0; i < _buffer.length; i++) {
      var v = _buffer[i];
      var v1 = (v >> 4) & 0xF;
      var v2 = v & 0xF;
      b.write('${vv[v1]}${vv[v2]}');
    }
    return b.toString();
  }
}
