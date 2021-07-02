import 'package:rabbits/model/rabbit_child_model.dart';

abstract class RabbitChildEvent {}

class ResetToInitial extends RabbitChildEvent {}

class Add extends RabbitChildEvent {
  final RabbitChildModel rabbitChildModel;
  Add({required this.rabbitChildModel});
}

class GetAllRabbits extends RabbitChildEvent {}

//? delete rabbit from database event
class DeleteRabbit extends RabbitChildEvent {
  final String rabbitKey;
  DeleteRabbit({required this.rabbitKey});
}

//? reset event
class ResetToZero extends RabbitChildEvent {
  final String rabbitKey;
  final String homeName;
  ResetToZero({required this.rabbitKey, required this.homeName});
}

//? update name
class ChangeHomeName extends RabbitChildEvent {
  final String rabbitKey;
  final String homeName;
  ChangeHomeName({required this.rabbitKey, required this.homeName});
}

//? update pet weight
class ChangePetWeight extends RabbitChildEvent {
  final String rabbitKey;
  final String petWeight;
  ChangePetWeight({required this.rabbitKey, required this.petWeight});
}

//? update pet born
class ChangePetBorn extends RabbitChildEvent {
  final String stringDateTime;
  final String rabbitKey;
  ChangePetBorn({required this.rabbitKey, required this.stringDateTime});
}

//? update food count
class IncrementFood extends RabbitChildEvent {
  final String rabbitKey;
  IncrementFood({required this.rabbitKey});
}

class DecrementFood extends RabbitChildEvent {
  final String rabbitKey;
  DecrementFood({required this.rabbitKey});
}

class GetRabbitByKey extends RabbitChildEvent {
  final String rabbitKey;
  GetRabbitByKey({required this.rabbitKey});
}

class DeleteAllDatabase extends RabbitChildEvent {}
