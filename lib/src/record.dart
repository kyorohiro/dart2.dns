import 'package:info.kyorohiro.dns/dns.dart';
import 'package:tuple/tuple.dart' show Tuple2;

class DNSRecord {
  String name; //xx bit
  int type; //16bit
  int clazz; //16bit
  int ttl; // 32bit
  int rdlength; // 16bit
  List<int> rdata; // edlength bytes;
  static Tuple2<List<DNSRecord>, int> decode(DNSBuffer buffer, int index, int count) {
    var indexTmp = index;
    var records = <DNSRecord>[];
    for (var i = 0; i < count; i++) {
      var record = DNSRecord();
      var name = DNSName.createUrlFromName(buffer.raw, indexTmp, buffer.raw.length);
      record.name = name.item1;
      record.type = buffer.getInt16AtBE(indexTmp + name.item2);
      record.clazz = buffer.getInt16AtBE(indexTmp + name.item2 + 2);
      record.ttl = buffer.getInt32AtBE(indexTmp + name.item2 + 2 + 2);
      record.rdlength = buffer.getInt16AtBE(indexTmp + name.item2 + 2 + 2 + 4);
      record.rdata = buffer.subBuffer(indexTmp + name.item2 + 2 + 2 + 4 + 2, record.rdlength).raw;
      indexTmp += indexTmp + name.item2 + 2 + 2 + 4 + 2 + record.rdlength;
      records.add(record);
    }
    return Tuple2(records, indexTmp - index);
  }
}
