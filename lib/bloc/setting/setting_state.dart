abstract class SettingState {}

class Initial extends SettingState {}

class OnLoading extends SettingState {}

class OnGetAllSettingCompleted extends SettingState {
  final Map<String, dynamic> map;
  OnGetAllSettingCompleted({required this.map});
}

// * ------------------------------------------------------
// * load event
// * ------------------------------------------------------
//? on load food unit
class OnLoadFoodUnit extends SettingState {
  final String foodUnit;
  OnLoadFoodUnit({required this.foodUnit});
}

//? on load weight unit
class OnLoadWeightUnit extends SettingState {
  final String weightUnit;
  OnLoadWeightUnit({required this.weightUnit});
}

//? on load food price
class OnLoadFoodPrice extends SettingState {
  final String foodPrice;
  OnLoadFoodPrice({required this.foodPrice});
}

//? on load pet price
class OnLoadPetPrice extends SettingState {
  final String petPrice;
  OnLoadPetPrice({required this.petPrice});
}

//? on load food weight
class OnLoadFoodWeight extends SettingState {
  final String foodWeight;
  OnLoadFoodWeight({required this.foodWeight});
}

// * ------------------------------------------------------
// * change or update event
// * ------------------------------------------------------
//? on change food unit
class OnChangeFoodUnit extends SettingState {
  final String foodUnit;
  OnChangeFoodUnit({required this.foodUnit});
}

//? on change weight unit
class OnChangeWeightUnit extends SettingState {
  final String weightUnit;
  OnChangeWeightUnit({required this.weightUnit});
}

//? on change food price
class OnChangeFoodPrice extends SettingState {
  final String foodPrice;
  OnChangeFoodPrice({required this.foodPrice});
}

//? on change pet price
class OnChangePetPrice extends SettingState {
  final String petPrice;
  OnChangePetPrice({required this.petPrice});
}

//? on change food weight
class OnChangeFoodWeight extends SettingState {
  final String foodWeight;
  OnChangeFoodWeight({required this.foodWeight});
}

//* on change rabbit parent estimate born
class OnChangeRabbitParentEstimateBorn extends SettingState {
  final String rabbitParentEstimateBorn;
  OnChangeRabbitParentEstimateBorn({required this.rabbitParentEstimateBorn});
}

//* on change rabbit parent add box
class OnChangeRabbitParentAddBox extends SettingState {
  final String rabbitParentAddBox;
  OnChangeRabbitParentAddBox({required this.rabbitParentAddBox});
}
