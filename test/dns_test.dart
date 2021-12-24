import 'package:dart2.dns/dns.dart';
import 'package:test/test.dart';
import 'dart:typed_data' show Uint8List;

void main() {
  group('DNSHeader', () {
    setUp(() {});

    test('DNSheader.encode()', () {
      var out = DNSName.urlToQname('github.com');
      var ret = [6, 0x67, 0x69, 0x74, 0x68, 0x75, 0x62, 3, 0x63, 0x6f, 0x6d, 0x00];
      expect(out.length, ret.length);
      expect(out, ret);
    });
  });
  group('DNS', () {
    setUp(() {});

    test('DNS.urlToQname', () {
      var out = DNSName.urlToQname('github.com');
      var ret = [6, 0x67, 0x69, 0x74, 0x68, 0x75, 0x62, 3, 0x63, 0x6f, 0x6d, 0x00];
      expect(out.length, ret.length);
      expect(out, ret);
    });

    test('DNS.qnameToUrl', () {
      var src = [6, 0x67, 0x69, 0x74, 0x68, 0x75, 0x62, 3, 0x63, 0x6f, 0x6d, 0x00];
      var exp = 'github.com';
      var out = DNSName.qnameToUrl(Uint8List.fromList(src), 0, src.length);
      expect(out.item1, exp);
      expect(out.item2, src.length - 1);
    });

    test('DNS.qnameToUrl with compression', () {
      {
        var src = [6, 0x67, 0x69, 0x74, 0x68, 0x75, 0x62, 3, 0x63, 0x6f, 0x6d, 0x00, 0xC7];
        var exp = 'com';
        var out = DNSName.qnameToUrl(Uint8List.fromList(src), 12, src.length);
        expect(out.item1, exp);
        expect(out.item2, src.length);
      }
      {
        var src = [6, 0x67, 0x69, 0x74, 0x68, 0x75, 0x62, 3, 0x63, 0x6f, 0x6d, 0x00, 6, 0x67, 0x69, 0x74, 0x68, 0x75, 0x62, 3, 0x63, 0x6f, 0x6d, 0xC7];
        var exp = 'github.com.com';
        var out = DNSName.qnameToUrl(Uint8List.fromList(src), 12, src.length);
        expect(out.item1, exp);
        expect(out.item2, src.length);
      }
    });

    test('DNS.namesToUrls', () {
      var src = [6, 0x67, 0x69, 0x74, 0x68, 0x75, 0x62, 3, 0x63, 0x6f, 0x6d, 0x00, 6, 0x67, 0x69, 0x74, 0x68, 0x75, 0x62, 3, 0x63, 0x6f, 0x6d, 0x00];
      var exp = ['github.com', 'github.com'];
      var out = DNSName.qnamesToUrls(Uint8List.fromList(src), src.length, 2);
      expect(out.item1, exp);
      expect(out.item2, src.length);
    });

    test('DNS.namesToUrls with compress', () {
      var src = [6, 0x67, 0x69, 0x74, 0x68, 0x75, 0x62, 3, 0x63, 0x6f, 0x6d, 0x00, 6, 0x67, 0x69, 0x74, 0x68, 0x75, 0x62, 3, 0x63, 0x6f, 0x6d, 0xC7, 0x00];
      var exp = ['github.com', 'github.com.com'];
      var out = DNSName.qnamesToUrls(Uint8List.fromList(src), src.length, 2);
      expect(out.item1, exp);
      expect(out.item2, src.length);
    });
  });
}