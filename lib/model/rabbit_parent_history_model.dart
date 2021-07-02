class RabbitParentHistoryModel {
  static const keyKey = 'a';
  static const bornDateKey = 'b';
  static const marryDateKey = 'c';
  static const childCountKey = 'd';
  static const dayPassedCountKey = 'e';
  static const parentKeyKey = 'f';

  String? key;
  String? bornDate;
  String? marryDate;
  String? childCount;
  String? dayPassedCount;
  String? parentKey;

  RabbitParentHistoryModel({
    this.key,
    this.bornDate,
    this.marryDate,
    this.childCount,
    this.dayPassedCount,
    this.parentKey,
  });

  RabbitParentHistoryModel.fromMap(Map<String, dynamic> map) {
    key = map[keyKey];
    bornDate = map[bornDateKey];
    marryDate = map[marryDateKey];
    childCount = map[childCountKey];
    dayPassedCount = map[dayPassedCountKey];
    parentKey = map[parentKeyKey];
  }

  Map<String, dynamic> toMap() => {
        keyKey: key,
        bornDateKey: bornDate,
        marryDateKey: marryDate,
        childCountKey: childCount,
        dayPassedCountKey: dayPassedCount,
        parentKeyKey: parentKey,
      };
}
