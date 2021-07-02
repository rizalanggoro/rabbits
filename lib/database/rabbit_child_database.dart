import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class RabbitChildDatabase {
  Completer<Database>? _completer;

  Future<Database> openDatabase() async {
    _completer ??= Completer();

    var _a = await getApplicationDocumentsDirectory();
    var _b = 'rabbit_child.db';
    var _c =
        await databaseFactoryIo.openDatabase(join(_a.path, _b), version: 1);
    _completer!.complete(_c);
    return _completer!.future;
  }
}
