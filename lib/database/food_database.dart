import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class FoodDatabase {
  Future<Database> openDatabase() async {
    var _a = await getApplicationDocumentsDirectory();
    var _b = 'food.db';
    var _c = join(_a.path, _b);
    var _d = await databaseFactoryIo.openDatabase(
      _c,
      version: 1,
    );
    return _d;
  }
}
