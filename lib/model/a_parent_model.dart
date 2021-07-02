class AParentModel {
  // key
  static const parentKeyKey = 'a';
  static const parentNameKey = 'b';
  static const parentMarryDateKey = 'c';
  static const parentStatusKey = 'd';

  String? parentKey;
  String? parentName;
  String? parentMarryDate;
  String? parentStatus;

  AParentModel({
    this.parentKey,
    this.parentName,
    this.parentMarryDate,
    this.parentStatus,
  });

  AParentModel.fromMap(Map<String, dynamic> map) {
    parentKey = map[parentKeyKey];
    parentName = map[parentNameKey];
    parentMarryDate = map[parentMarryDateKey];
    parentStatus = map[parentStatusKey];
  }

  Map<String, dynamic> toMap() => {
        parentKeyKey: parentKey,
        parentNameKey: parentName,
        parentMarryDateKey: parentMarryDate,
        parentStatusKey: parentStatus,
      };
}
