class RabbitParentModel {
  //* key
  static const keyKey = 'a';
  static const parentNameKey = 'b';
  static const statusKey = 'c';
  static const marryDateKey = 'd';

  //* field
  String? key;
  String? parentName;
  String? status;
  String? marryDate;

  RabbitParentModel({
    this.key,
    this.parentName,
    this.status,
    this.marryDate,
  });

  RabbitParentModel.fromJson(Map<String, dynamic> map) {
    key = map[keyKey];
    parentName = map[parentNameKey];
    status = map[statusKey];
    marryDate = map[marryDateKey];
  }

  Map<String, dynamic> toMap() => {
        keyKey: key,
        parentNameKey: parentName,
        statusKey: status,
        marryDateKey: marryDate,
      };
}
