import 'dart:io';

import 'package:path_provider/path_provider.dart';

class _FileHelperImpl {
  Future<String> getFilePath(String uniqueFileNameWithExtension) async {
    Directory directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$uniqueFileNameWithExtension';
  }
}

// ignore: non_constant_identifier_names
final _FileHelperImpl FileHelper = _FileHelperImpl();