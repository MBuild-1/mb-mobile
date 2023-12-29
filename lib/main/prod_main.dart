import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:masterbagasi/main.dart' as starter_main;

void main() async {
  await dotenv.load(fileName: ".env.prod");
  await starter_main.main();
}