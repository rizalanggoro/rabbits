class AChildModel {
  // key
  static const childKeyKey = 'a';
  static const childNameKey = 'b';
  static const childBornDateKey = 'c';
  static const childWeightKey = 'd';
  static const childFoodMapKey = 'e';
  // end key

  String? childKey;
  String? childName;
  String? childBornDate;
  String? childWeight;
  String? childFoodMap;

  AChildModel({
    this.childKey,
    this.childName,
    this.childBornDate,
    this.childWeight,
    this.childFoodMap,
  });

  AChildModel.fromMap(Map<String, dynamic> map) {
    childKey = map[childKeyKey];
    childName = map[childNameKey];
    childBornDate = map[childBornDateKey];
    childWeight = map[childWeightKey];
    childFoodMap = map[childFoodMapKey];
  }

  Map<String, dynamic> toMap() => {
        childKeyKey: childKey,
        childNameKey: childName,
        childBornDateKey: childBornDate,
        childWeightKey: childWeight,
        childFoodMapKey: childFoodMap,
      };
}
