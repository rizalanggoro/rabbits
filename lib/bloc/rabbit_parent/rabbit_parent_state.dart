import 'package:rabbits/model/rabbit_parent_model.dart';

abstract class RabbitParentState {}

// * -------------------------------------------------
// * default state
// * -------------------------------------------------
class OnInitial extends RabbitParentState {}

class OnLoading extends RabbitParentState {}

// * -------------------------------------------------
// * event
// * -------------------------------------------------
class OnAddedRabbitParent extends RabbitParentState {
  final RabbitParentModel rabbitParentModel;
  OnAddedRabbitParent({required this.rabbitParentModel});
}

class OnGetAllRabbitParentCompleted extends RabbitParentState {
  final List<RabbitParentModel> listRabbitParentModel;
  final List<String> listRabbitParentKey;
  OnGetAllRabbitParentCompleted({
    required this.listRabbitParentModel,
    required this.listRabbitParentKey,
  });
}

class OnGetRabbitParentByKey extends RabbitParentState {
  final RabbitParentModel rabbitParentModel;
  OnGetRabbitParentByKey({required this.rabbitParentModel});
}

class OnChangeRabbitParentMarryDate extends RabbitParentState {
  final String parentKey;
  final String marryDateTime;
  OnChangeRabbitParentMarryDate({
    required this.parentKey,
    required this.marryDateTime,
  });
}

class OnChangeRabbitParentStatus extends RabbitParentState {
  final String parentKey;
  final String parentStatus;
  OnChangeRabbitParentStatus({
    required this.parentKey,
    required this.parentStatus,
  });
}

class OnChangeRabbitParentName extends RabbitParentState {
  final String parentKey;
  final String parentName;
  OnChangeRabbitParentName({
    required this.parentKey,
    required this.parentName,
  });
}

class OnResetRabbitParent extends RabbitParentState {
  final String parentKey;
  OnResetRabbitParent({required this.parentKey});
}

class OnDeleteRabbitParentFromDatabase extends RabbitParentState {
  final String parentKey;
  OnDeleteRabbitParentFromDatabase({required this.parentKey});
}
