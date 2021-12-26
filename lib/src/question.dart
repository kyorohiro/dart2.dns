import 'package:dart2.dns/dns.dart';
import 'package:tuple/tuple.dart' show Tuple2;

///
///
/// QCLASS: 16bit
class DNSQuestion {
  String hostOrIP = 'github.com'; // QNAME: X bit
  int qType = DNS.QTYPE_A; // QTYPE: 16bit
  int qClass = DNS.QCLASS_IN; // QCLASS: 16bit

  DNSBuffer generateBuffer() {
    return DNSQuestion.encode(this);
  }

  static DNSBuffer encode(DNSQuestion q) {
    var qnameBuffer = DNSName.urlToQname(q.hostOrIP);
    var buffer = DNSBuffer(qnameBuffer.length + 2 + 2);
    buffer.setBytes(0, qnameBuffer);
    buffer.setInt16AtBigEndian(qnameBuffer.length, q.qType);
    buffer.setInt16AtBigEndian(qnameBuffer.length + 2, q.qClass);
    return buffer;
  }

  static Tuple2<List<DNSQuestion>, int> decode(DNSBuffer buffer, int index, int count) {
    var questions = <DNSQuestion>[];
    var indexTmp = index;
    for (var i = 0; i < count; i++) {
      var question = DNSQuestion();
      var url = DNSName.qnameToUrl(buffer.raw, indexTmp, buffer.raw.length);
      question.hostOrIP = url.item1;
      question.qType = buffer.getInt16FromBigEndian(indexTmp + url.item2 + 1);
      question.qClass = buffer.getInt16FromBigEndian(indexTmp + url.item2 + 1 + 2);
      questions.add(question);
      indexTmp += url.item2 + 1 + 4;
    }
    return Tuple2<List<DNSQuestion>, int>(questions, indexTmp - index);
  }
}
