import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class RabbitParentHistoryDatabase {
  Future<Database> openDatabase() async {
    var _a = await getApplicationDocumentsDirectory();
    var _b = 'rabbit-parent-history.db';
    var _c = await databaseFactoryIo.openDatabase(
      join(_a.path, _b),
      version: 1,
    );
    return _c;
  }
}
