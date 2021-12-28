// var dict = DNSCompressionDict();
import 'package:info.kyorohiro.dns/dns.dart';
import 'package:test/test.dart';
import 'dart:typed_data' show Uint8List;

void main() {
  group('DNSName', () {
    setUp(() {});

    test('DNSName.encode()', () {
      var dict = DNSCompressionDict();
      int index = 0;
      {
        var bufferSrc = dict.add('yahoo.co.jp', 0);
        index += bufferSrc.length;
        expect(DNSBuffer.fromList(bufferSrc).toHex(), '057961686f6f02636f026a7000');
      }
//057961686f6f02636f026a7000(13)
//06676f6f676c65c006(9)
      {
        var bufferSrc = dict.add('google.co.jp', index);
        index += bufferSrc.length;
        expect(DNSBuffer.fromList(bufferSrc).toHex(), '06676f6f676c65c006');
      }
//057961686f6f02636f026a7000(13)
//06676f6f676c65c006(9)
//03777777c00d(6)
      {
        var bufferSrc = dict.add('www.google.co.jp', index);
        index += bufferSrc.length;
        expect(DNSBuffer.fromList(bufferSrc).toHex(), '03777777c00d');
      }
      {
        var bufferSrc = dict.add('www.google.co.jp', index);
        index += bufferSrc.length;
        expect(DNSBuffer.fromList(bufferSrc).toHex(), 'c016');
      }
    });
  });
}
