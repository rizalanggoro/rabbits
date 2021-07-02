import 'package:rabbits/model/a_child_model.dart';
import 'package:rabbits/model/a_parent_model.dart';
import 'package:rabbits/model/food_model.dart';

class AStatic {
  // parent
  static String parentEstimateBorn = '0';
  static String parentAddBox = '0';

  // child
  static String childSellUnit = '0';
  static String childSellPrice = '0.0';

  // list food
  static List<String> listFoodKey = [];
  static List<FoodModel> listFoodModel = [];

  // list parent
  static List<String> listPregnantParentKey = [];
  static List<AParentModel> listPregnantParentModel = [];
  static List<String> listParentKey = [];
  static List<AParentModel> listParentModel = [];

  // list child
  static List<String> listChildKey = [];
  static List<AChildModel> listChildModel = [];
}
