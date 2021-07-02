class FoodModel {
  String? key;
  String? foodName;
  String? foodUnit;
  String? foodWeightPerDose;
  String? foodPricePerUnit;
  String? foodPricePerDose;

  // key
  static const keyKey = 'a';
  static const foodNameKey = 'b';
  static const foodUnitKey = 'c';
  static const foodWeightPerDoseKey = 'd';
  static const foodPricePerUnitKey = 'e';
  static const foodPricePerDoseKey = 'f';

  FoodModel({
    this.key,
    this.foodName,
    this.foodUnit,
    this.foodWeightPerDose,
    this.foodPricePerUnit,
    this.foodPricePerDose,
  });

  FoodModel.fromMap(Map<String, dynamic> map) {
    key = map[keyKey];
    foodName = map[foodNameKey];
    foodUnit = map[foodUnitKey];
    foodWeightPerDose = map[foodWeightPerDoseKey];
    foodPricePerUnit = map[foodPricePerUnitKey];
    foodPricePerDose = map[foodPricePerDoseKey];
  }

  Map<String, dynamic> toMap() => {
        keyKey: key,
        foodNameKey: foodName,
        foodUnitKey: foodUnit,
        foodWeightPerDoseKey: foodWeightPerDose,
        foodPricePerUnitKey: foodPricePerUnit,
        foodPricePerDoseKey: foodPricePerDose,
      };
}
