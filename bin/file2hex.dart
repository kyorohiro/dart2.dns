import 'dart:io' as io;
import 'package:dart2.dns/dns.dart';

main(List<String> argv) async {
  print("hello!! ${argv}");
  var filepath = './d.dat';
  if (argv.length > 0) {
    filepath = argv[0];
  }
  var f = io.File(filepath);
  var bytes = await f.readAsBytes();
  var buffer = new Buffer.fromList(bytes);
  print(buffer.toString());
}
