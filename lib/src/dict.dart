import 'dart:convert';
import 'dart:typed_data' show Uint8List;

class DNSCompressionDictItem {
  int index;
}

class DNSCompressionDict {
  Map<String, DNSCompressionDictItem> dict = {};
  Uint8List add(String item, int index) {
    var items = item.split('.');
    var buffer = <int>[];
    for (var i = 0; i < items.length; i++) {
      var key = items.sublist(i).join('.');
      print(key);
      if (dict.containsKey(key)) {
        buffer.addAll([0xC0, dict[key].index]);
        return Uint8List.fromList(buffer);
      } else {
        buffer.add(items[i].length);
        buffer.addAll(ascii.encode(items[i]));
        dict[key] = DNSCompressionDictItem()..index = index;
        index += items[i].length + 1;
      }
    }
    if (buffer.isNotEmpty) {
      buffer.add(0);
    }
    return Uint8List.fromList(buffer);
  }
}
