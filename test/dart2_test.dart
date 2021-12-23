import 'package:dart2.dns/dns.dart';
import 'package:test/test.dart';
import 'dart:typed_data' show Uint8List;

void main() {
  group('A group of tests', () {
    setUp(() {});

    test('DNS.urlToQname', () {
      var out = DNS.urlToQname('github.com');
      var ret = [6, 0x67, 0x69, 0x74, 0x68, 0x75, 0x62, 3, 0x63, 0x6f, 0x6d, 0x00];
      expect(out.length, ret.length);
      expect(out, ret);
    });

    test('DNS.qnameToUrl', () {
      var src = [6, 0x67, 0x69, 0x74, 0x68, 0x75, 0x62, 3, 0x63, 0x6f, 0x6d, 0x00];
      var exp = 'github.com';
      var out = DNS.qnameToUrl(Uint8List.fromList(src), src.length);
      expect(out.item1, exp);
      expect(out.item2, src.length);
    });
  });
}
