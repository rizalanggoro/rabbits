part of 'a_parent_history_bloc.dart';

@immutable
abstract class AParentHistoryEvent {}

class AParentHistoryResetInitial extends AParentHistoryEvent {}

class AParentHistoryAdd extends AParentHistoryEvent {
  final AParentHistoryModel parentHistoryModel;
  AParentHistoryAdd({required this.parentHistoryModel});
}

class AParentHistoryDelete extends AParentHistoryEvent {
  final String parentKey;
  final String historyKey;
  AParentHistoryDelete({
    required this.parentKey,
    required this.historyKey,
  });
}

class AParentHistoryDeleteStore extends AParentHistoryEvent {
  final String parentKey;
  AParentHistoryDeleteStore({required this.parentKey});
}
