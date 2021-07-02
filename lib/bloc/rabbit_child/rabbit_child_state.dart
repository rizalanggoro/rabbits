import 'package:rabbits/model/rabbit_child_model.dart';

abstract class RabbitChildState {}

class Initial extends RabbitChildState {}

class OnLoading extends RabbitChildState {}

class OnAdd extends RabbitChildState {
  final RabbitChildModel rabbitChildModel;
  OnAdd({required this.rabbitChildModel});
}

//? on delete rabbit from database event
class OnDeletedRabbit extends RabbitChildState {
  final String rabbitKey;
  OnDeletedRabbit({required this.rabbitKey});
}

//? reset to zero event
class OnResetToZeroCompleted extends RabbitChildState {
  final String rabbitKey;
  final RabbitChildModel rabbitChildModel;
  OnResetToZeroCompleted({
    required this.rabbitKey,
    required this.rabbitChildModel,
  });
}

//? update home name
class OnChangeHomeName extends RabbitChildState {
  final String rabbitKey;
  final String homeName;
  OnChangeHomeName({required this.rabbitKey, required this.homeName});
}

//? update pet weight
class OnChangePetWeight extends RabbitChildState {
  final String rabbitKey;
  final String petWeight;
  OnChangePetWeight({required this.rabbitKey, required this.petWeight});
}

//? update pet born
class OnChangePetBorn extends RabbitChildState {
  final String stringDateTime;
  final String rabbitKey;
  OnChangePetBorn({required this.rabbitKey, required this.stringDateTime});
}

//? update food count
class OnIncrementFood extends RabbitChildState {
  final String rabbitKey;
  final String foodCount;
  OnIncrementFood({required this.rabbitKey, required this.foodCount});
}

class OnDecrementFood extends RabbitChildState {
  final String rabbitKey;
  final String foodCount;
  OnDecrementFood({required this.rabbitKey, required this.foodCount});
}

class OnDeleteDatabaseSuccess extends RabbitChildState {}

class OnGetAllCompleted extends RabbitChildState {
  final List<RabbitChildModel> listRabbitChild;
  final List<String> listRabbitChildKey;
  OnGetAllCompleted({
    required this.listRabbitChildKey,
    required this.listRabbitChild,
  });
}

class OnGetByKeyCompleted extends RabbitChildState {
  final RabbitChildModel rabbitChildModel;
  OnGetByKeyCompleted({required this.rabbitChildModel});
}
