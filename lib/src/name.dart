import 'dart:convert' show ascii;
import 'dart:typed_data' show Uint8List;
import 'package:info.kyorohiro.dns/src/dict.dart';
import 'package:tuple/tuple.dart' show Tuple2;
import 'package:info.kyorohiro.dns/dns.dart' show DNSCompressionDict;

class DNSName {
  ///
  /// create QName Buffer from url
  ///
  static Uint8List createNameFromUrl(String url, {DNSCompressionDict dict, int index = 0}) {
    dict ??= DNSCompressionDict();
    return dict.add(url, 0);
  }

  ///
  /// create url string from qname buffer.
  ///
  /// return values
  ///   string item is url
  ///   int item is length with Null(0)
  static Tuple2<String, int> createUrlFromName(Uint8List srcBuffer, int index, int length) {
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
        var r = createUrlFromName(srcBuffer, v, length);
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
