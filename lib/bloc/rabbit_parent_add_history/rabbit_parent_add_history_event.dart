import 'package:rabbits/model/rabbit_parent_history_model.dart';

abstract class RabbitParentAddHistoryEvent {}

class ResetRabbitParentHistoryToInitial extends RabbitParentAddHistoryEvent {}

class RabbitParentHistoryResetDefaultValue extends RabbitParentAddHistoryEvent {
}

class RabbitParentHistoryChangeBornDate extends RabbitParentAddHistoryEvent {
  final String dateTimeBorn;
  RabbitParentHistoryChangeBornDate({required this.dateTimeBorn});
}

class RabbitParentHistoryChangeChildCount extends RabbitParentAddHistoryEvent {
  final String childCount;
  RabbitParentHistoryChangeChildCount({required this.childCount});
}

class RabbitParentHistoryAddModel extends RabbitParentAddHistoryEvent {
  final String parentKey;
  final RabbitParentHistoryModel rabbitParentHistoryModel;
  RabbitParentHistoryAddModel({
    required this.parentKey,
    required this.rabbitParentHistoryModel,
  });
}

class GetAllRabbitParentHistory extends RabbitParentAddHistoryEvent {
  final String parentKey;
  GetAllRabbitParentHistory({required this.parentKey});
}

class DeleteRabbitParentHistory extends RabbitParentAddHistoryEvent {
  final String parentKey;
  final String historyKey;
  DeleteRabbitParentHistory({
    required this.parentKey,
    required this.historyKey,
  });
}

class DeleteRabbitHistoryStoreRef extends RabbitParentAddHistoryEvent {
  final String parentKey;
  DeleteRabbitHistoryStoreRef({required this.parentKey});
}
