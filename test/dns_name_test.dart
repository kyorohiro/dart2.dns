import 'package:info.kyorohiro.dns/dns.dart';
import 'package:test/test.dart';
import 'dart:typed_data' show Uint8List;

void main() {
  group('DNSName', () {
    setUp(() {});

    test('DNSName.encode()', () {
      var out = DNSName.createNameFromUrl('github.com');
      var ret = [6, 0x67, 0x69, 0x74, 0x68, 0x75, 0x62, 3, 0x63, 0x6f, 0x6d, 0x00];
      expect(out.length, ret.length);
      expect(out, ret);
    });
  });
  group('DNS', () {
    setUp(() {});

    test('DNS.urlToQname', () {
      var out = DNSName.createNameFromUrl('github.com');
      var ret = [6, 0x67, 0x69, 0x74, 0x68, 0x75, 0x62, 3, 0x63, 0x6f, 0x6d, 0x00];
      expect(out.length, ret.length);
      expect(out, ret);
    });

    test('DNS.qnameToUrl', () {
      var src = [6, 0x67, 0x69, 0x74, 0x68, 0x75, 0x62, 3, 0x63, 0x6f, 0x6d, 0x00];
      var exp = 'github.com';
      var out = DNSName.createUrlFromName(Uint8List.fromList(src), 0);
      expect(out.item1, exp);
      expect(out.item2, src.length);
    });

    test('DNS.qnameToUrl with compression', () {
      {
        var src = [6, 0x67, 0x69, 0x74, 0x68, 0x75, 0x62, 3, 0x63, 0x6f, 0x6d, 0x00, 0xC0, 0x07];
        var exp = 'com';
        var out = DNSName.createUrlFromName(Uint8List.fromList(src), 12);
        expect(out.item1, exp);
        expect(out.item2, src.length - 12);
      }
      {
        var src = [6, 0x67, 0x69, 0x74, 0x68, 0x75, 0x62, 3, 0x63, 0x6f, 0x6d, 0x00, 6, 0x67, 0x69, 0x74, 0x68, 0x75, 0x62, 3, 0x63, 0x6f, 0x6d, 0xC0, 0x07];
        var exp = 'github.com.com';
        var out = DNSName.createUrlFromName(Uint8List.fromList(src), 12);
        expect(out.item1, exp);
        expect(out.item2, src.length - 12);
      }
    });
  });
}
