import 'package:rabbits/model/rabbit_parent_model.dart';

abstract class RabbitParentEvent {}

class ResetToInitial extends RabbitParentEvent {}

class DeleteDatabaseRabbitParent extends RabbitParentEvent {}

class AddRabbitParent extends RabbitParentEvent {
  final RabbitParentModel rabbitParentModel;
  AddRabbitParent({required this.rabbitParentModel});
}

class GetAllRabbitParent extends RabbitParentEvent {}

class GetRabbitParentByKey extends RabbitParentEvent {
  final String parentKey;
  GetRabbitParentByKey({required this.parentKey});
}

class ChangeRabbitParentMarryDate extends RabbitParentEvent {
  final String parentKey;
  final String marryDateTime;
  ChangeRabbitParentMarryDate({
    required this.parentKey,
    required this.marryDateTime,
  });
}

class ChangeRabbitParentStatus extends RabbitParentEvent {
  final String parentKey;
  final String parentStatus;
  ChangeRabbitParentStatus({
    required this.parentKey,
    required this.parentStatus,
  });
}

class ChangeRabbitParentName extends RabbitParentEvent {
  final String parentKey;
  final String parentName;
  ChangeRabbitParentName({
    required this.parentKey,
    required this.parentName,
  });
}

class ResetRabbitParentToZero extends RabbitParentEvent {
  final String parentKey;
  final String parentName;
  ResetRabbitParentToZero({
    required this.parentKey,
    required this.parentName,
  });
}

class DeleteRabbitParentFromDatabase extends RabbitParentEvent {
  final String parentKey;
  DeleteRabbitParentFromDatabase({required this.parentKey});
}
