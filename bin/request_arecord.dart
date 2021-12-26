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
  print(requestBuffer.toBase64());
  var client = io.HttpClient();

  var request = await client.getUrl(Uri(scheme: 'https', host: 'dns.google', path: 'dns-query', query: "dns=${requestBuffer.toBase64().replaceAll('=', '')}"));
  var response = await request.close();
  var responseBuffer = <int>[];
  await for (var part in response) {
    responseBuffer.addAll(part);
  }
  var dnsBuffer = DNSBuffer.fromList(responseBuffer);
  print(response.statusCode);
  print(DNSBuffer.fromList(responseBuffer).toString());
  print(utf8.decode(responseBuffer, allowMalformed: true));

  var header = DNSHeader.decode(dnsBuffer);
  var questionInfo = DNSQuestion.decode(dnsBuffer, DNSHeader.BUFFER_SIZE, header.qdcount);
  var anRecordInfo = DNSRecord.decode(dnsBuffer, DNSHeader.BUFFER_SIZE + questionInfo.item2, header.ancount);
  var nsRecordInfo = DNSRecord.decode(dnsBuffer, DNSHeader.BUFFER_SIZE + questionInfo.item2 + anRecordInfo.item2, header.nscount);
  var arRecordInfo = DNSRecord.decode(dnsBuffer, DNSHeader.BUFFER_SIZE + questionInfo.item2 + anRecordInfo.item2 + nsRecordInfo.item2, header.arcount);

  
}
