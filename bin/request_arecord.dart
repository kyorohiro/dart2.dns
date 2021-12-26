import 'dart:typed_data';

import 'package:dart2.dns/dns.dart';
import 'dart:io' as io;

main(List<String> argv) async {
  print("hello!! ${argv}");
  var domain = 'github.com';
  if (argv.length > 0) {
    domain = argv[0];
  }
  var requestBuffer = DNS().generateAMessage(domain);
  print(requestBuffer.toBase64());
  var client = io.HttpClient();

  var request = await client.getUrl(Uri(scheme: 'https', host: 'dns.google', path: 'dns-query', query: "dns=${requestBuffer.toBase64()}"));
  var response = await request.close();
  var responseBuffer = <int>[];
  await for (var part in response) {
    responseBuffer.addAll(part);
  }
  print(Buffer.fromList(responseBuffer).toString());
  //var buffer = DNS().generateAMessage("github.com");
  //print(buffer.toBase64());
  //var buffer = Buffer.fromHexString('0034818000010001000000000667697468756203636f6d0000010001c00c000100010000003c00043445ba2c');
  //var header = DNSHeader.decode(buffer);
  //var question = DNSQuestion.decode(buffer.subBuffer(12, -1), 0, header.qdcount);
}
