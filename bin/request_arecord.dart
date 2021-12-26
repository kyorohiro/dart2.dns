import 'dart:typed_data';

import 'package:dart2.dns/dns.dart' show DNS, DNSHeader, DNSQuestion, DNSRecord, DNSBuffer;
import 'dart:io' as io;
import 'dart:convert' show utf8;

main(List<String> argv) async {
  var domain = 'github.com';
  if (argv.length > 0) {
    domain = argv[0];
  }
  var requestBuffer = DNS().generateAMessage(domain);
  var requestQuery = requestBuffer.toBase64().replaceAll('=', '');
  print('; Request query');
  print(';; $requestQuery');
  print(';; -- ');

  var client = io.HttpClient();
  var request = await client.getUrl(Uri(scheme: 'https', host: 'dns.google', path: 'dns-query', query: "dns=${requestQuery}"));
  var response = await request.close();
  var responseBuffer = <int>[];
  await for (var part in response) {
    responseBuffer.addAll(part);
  }
  var dnsBuffer = DNSBuffer.fromList(responseBuffer);
  print('; Response');
  print(';; statusCode: ${response.statusCode}');
  print(';; body as hex: ${DNSBuffer.fromList(responseBuffer).toString()}');
  print(';; body as text: ${utf8.decode(responseBuffer, allowMalformed: true)}');
  print(';; -- ');

  var header = DNSHeader.decode(dnsBuffer);
  var questionInfo = DNSQuestion.decode(dnsBuffer, DNSHeader.BUFFER_SIZE, header.qdcount);
  var anRecordInfo = DNSRecord.decode(dnsBuffer, DNSHeader.BUFFER_SIZE + questionInfo.item2, header.ancount);
  var nsRecordInfo = DNSRecord.decode(dnsBuffer, DNSHeader.BUFFER_SIZE + questionInfo.item2 + anRecordInfo.item2, header.nscount);
  var arRecordInfo = DNSRecord.decode(dnsBuffer, DNSHeader.BUFFER_SIZE + questionInfo.item2 + anRecordInfo.item2 + nsRecordInfo.item2, header.arcount);

  if (header.qdcount > 0) {
    print('; Questions');
    for (var question in questionInfo.item1) {
      print(';; qName: ${question.qName}');
      print(';; qClass: ${question.qClass}');
      print(';; qType: ${question.qType}');
      print(';; -- ');
    }
  }
  if (header.ancount > 0) {
    for (var record in anRecordInfo.item1) {
      print(';; name: ${record.name}');
      print(';; type: ${record.type}');
      print(';; class: ${record.clazz}');
      print(';; ttl: ${record.ttl}');
      print(';; rdlength: ${record.rdlength}');
      print(';; rdata: ${record.rdata}');
      print(';; rdata athex: ${DNSBuffer.fromList(record.rdata).toString()}');
      print(';; -- ');
    }
  }
}
