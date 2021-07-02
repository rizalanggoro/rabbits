import 'package:rabbits/page/setting.dart';

abstract class SettingEvent {}

class ResetToInitial extends SettingEvent {}

class GetAllSetting extends SettingEvent {}

//? event load food unit
class LoadFoodUnit extends SettingEvent {}

//? event load weight unit
class LoadWeightUnit extends SettingEvent {}

//? event load food price
class LoadFoodPrice extends SettingEvent {}

//? event load pet price
class LoadPetPrice extends SettingEvent {}

//? event load food weight
class LoadFoodWeight extends SettingEvent {}

//? event change food unit
class ChangeFoodUnit extends SettingEvent {
  final String foodUnit;
  ChangeFoodUnit({required this.foodUnit});
}

//? event change weight unit
class ChangeWeightUnit extends SettingEvent {
  final String weightUnit;
  ChangeWeightUnit({required this.weightUnit});
}

class ChangeFoodPrice extends SettingEvent {
  final String foodPrice;
  ChangeFoodPrice({required this.foodPrice});
}

class ChangePetPrice extends SettingEvent {
  final String petPrice;
  ChangePetPrice({required this.petPrice});
}

class ChangeFoodWeight extends SettingEvent {
  final String foodWeight;
  ChangeFoodWeight({required this.foodWeight});
}

class ChangeRabbitParentEstimateBorn extends SettingEvent {
  final String rabbitParentEstimateBorn;
  ChangeRabbitParentEstimateBorn({required this.rabbitParentEstimateBorn});
}

class ChangeRabbitParentAddBox extends SettingEvent {
  final String rabbitParentAddBox;
  ChangeRabbitParentAddBox({required this.rabbitParentAddBox});
}
