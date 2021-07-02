class RabbitChildModel {
  String? key;
  String? homeName;
  String? foodCount;
  String? petWeight;
  String? petBorn;

  RabbitChildModel({
    this.key,
    this.homeName,
    this.foodCount,
    this.petWeight,
    this.petBorn,
  });

  RabbitChildModel.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    homeName = json['homeName'];
    foodCount = json['foodCount'];
    petWeight = json['petWeight'];
    petBorn = json['petBorn'];
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'homeName': homeName,
      'foodCount': foodCount,
      'petWeight': petWeight,
      'petBorn': petBorn,
    };
  }
}
