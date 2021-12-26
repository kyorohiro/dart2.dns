import 'package:info.kyorohiro.dns/dns.dart' show DNS, DNSHeader, DNSQuestion, DNSRecord, DNSBuffer;
import 'dart:io' as io;
import 'dart:convert' show utf8;

main(List<String> argv) async {
  var domain = 'github.com';
  if (argv.isNotEmpty) {
    domain = argv[0];
  }
  var requestBuffer = DNS.generateAMessage(domain);
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

  var message = DNS.parseMessage(dnsBuffer);

  if (message.header.qdcount > 0) {
    print('; Questions');
    for (var question in message.question) {
      print(';; qName: ${question.qName}');
      print(';; qClass: ${question.qClass}');
      print(';; qType: ${question.qType}');
      print(';; -- ');
    }
  }
  if (message.header.ancount > 0) {
    print('; Answer');
    for (var record in message.answer) {
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

  if (message.header.nscount > 0) {
    print('; Authority');
    for (var record in message.authority) {
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

  if (message.header.arcount > 0) {
    print('; Additional');
    for (var record in message.additional) {
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
