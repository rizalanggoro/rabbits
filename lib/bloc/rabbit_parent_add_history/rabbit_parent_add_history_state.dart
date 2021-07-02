import 'package:rabbits/model/rabbit_parent_history_model.dart';

abstract class RabbitParentAddHistoryState {}

class OnInitial extends RabbitParentAddHistoryState {}

class OnLoading extends RabbitParentAddHistoryState {}

class OnResetDefaultValueRabbitParentHistory
    extends RabbitParentAddHistoryState {}

// on change rabbit parent born date
class OnChangeRabbitParentHistoryBornDate extends RabbitParentAddHistoryState {
  final String dateTimeBorn;
  OnChangeRabbitParentHistoryBornDate({required this.dateTimeBorn});
}

class OnChangeRabbitParentHistoryChildCount
    extends RabbitParentAddHistoryState {
  final String childCount;
  OnChangeRabbitParentHistoryChildCount({required this.childCount});
}

class OnAddedRabbitParentHistory extends RabbitParentAddHistoryState {
  final String parentKey;
  final RabbitParentHistoryModel rabbitParentHistoryModel;
  OnAddedRabbitParentHistory({
    required this.parentKey,
    required this.rabbitParentHistoryModel,
  });
}

class OnGetAllRabbitParentHistory extends RabbitParentAddHistoryState {
  final String parentKey;
  final List<String> listRabbitParentHistoryKey;
  final List<RabbitParentHistoryModel> listRabbitParentHistoryModel;
  OnGetAllRabbitParentHistory({
    required this.parentKey,
    required this.listRabbitParentHistoryKey,
    required this.listRabbitParentHistoryModel,
  });
}

class OnDeleteRabbitParentHistory extends RabbitParentAddHistoryState {
  final String historyKey;
  OnDeleteRabbitParentHistory({required this.historyKey});
}
