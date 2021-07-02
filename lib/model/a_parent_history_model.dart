class AParentHistoryModel {
  // key
  static const keyKey = 'a';
  static const marryDateKey = 'b';
  static const passedDayKey = 'c';
  static const bornDateKey = 'd';
  static const childCountKey = 'e';
  static const parentKeyKey = 'f';
  // end key

  String? key;
  String? marryDate;
  String? passedDay;
  String? bornDate;
  String? childCount;
  String? parentKey;

  AParentHistoryModel({
    this.key,
    this.marryDate,
    this.passedDay,
    this.bornDate,
    this.childCount,
    this.parentKey,
  });

  AParentHistoryModel.fromMap(Map<String, dynamic> map) {
    key = map[keyKey];
    marryDate = map[marryDateKey];
    passedDay = map[passedDayKey];
    bornDate = map[bornDateKey];
    childCount = map[childCountKey];
    parentKey = map[parentKeyKey];
  }

  Map<String, dynamic> toMap() => {
        keyKey: key,
        marryDateKey: marryDate,
        passedDayKey: passedDay,
        bornDateKey: bornDate,
        childCountKey: childCount,
        parentKeyKey: parentKey,
      };
}
