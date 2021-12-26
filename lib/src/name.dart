import 'dart:convert' show ascii;
import 'dart:typed_data' show Uint8List;
import 'package:tuple/tuple.dart' show Tuple2;

class DNSName {
  static Uint8List createQnameFromUrl(String url) {
    var urlBytes = ascii.encode(url);
    var buffer = List<int>.empty(growable: true);
    var tmp = List<int>.empty(growable: true);
    var tmpIndex = 0;
    //urlBytes.forEach((c)
    var tmpToBuffer = () {
      if (tmp.isNotEmpty) {
        buffer.add(tmpIndex);
        buffer.addAll(tmp.sublist(0, tmpIndex));
        tmpIndex = 0;
        tmp.clear();
      }
    };
    for (var i = 0; i < urlBytes.length; i++) {
      var c = urlBytes[i];
      if (0x2E == c) {
        tmpToBuffer();
        continue;
      } else {
        tmp.add(c);
        tmpIndex++;
      }
    }
    tmpToBuffer();
    buffer.add(0);
    return Uint8List.fromList(buffer);
  }

  ///
  ///
  /// ret
  ///   string item is url
  ///   int item is length with Null(0)
  static Tuple2<String, int> getUrlFromQname(Uint8List srcBuffer, int index, int length) {
    var outBuffer = StringBuffer();
    if (length > srcBuffer.length) {
      length = srcBuffer.length;
    }
    var i = index;
    for (; i < length;) {
      var nameLength = srcBuffer[i];
      if (nameLength == 0) {
        // if Null(0) is TEXT END
        i++;
        break;
      } else if ((0xC0 & nameLength) == 0xC0) {
        // compression
        var v = srcBuffer[++i];
        var r = getUrlFromQname(srcBuffer, v, length);
        if (outBuffer.length > 0) {
          outBuffer.write('.');
        }
        outBuffer.write(r.item1);
        i++;
        break;
      } else if (i + 1 + nameLength > length) {
        // anything wrong , return empty string
        throw Exception('>> [${i}] Wrong i+nameLength > length := ${i + 1 + nameLength} > $length');
      } else {
        var nameBytes = srcBuffer.sublist(i + 1, i + 1 + nameLength);
        if (outBuffer.length > 0) {
          outBuffer.write('.');
        }
        outBuffer.write(ascii.decode(nameBytes, allowInvalid: true));
        i = i + 1 + nameLength;
      }
    }
    return Tuple2<String, int>(outBuffer.toString(), i - index);
  }
}
