part of 'a_parent_history_bloc.dart';

@immutable
abstract class AParentHistoryState {}

class AParentHistoryInitial extends AParentHistoryState {}

class AParentHistoryOnAdd extends AParentHistoryState {
  final AParentHistoryModel parentHistoryModel;
  AParentHistoryOnAdd({required this.parentHistoryModel});
}

class AParentHistoryOnDelete extends AParentHistoryState {
  final String parentKey;
  final String historyKey;
  AParentHistoryOnDelete({required this.parentKey, required this.historyKey});
}

class AParentHistoryOnDeleteStore extends AParentHistoryState {
  final String parentKey;
  AParentHistoryOnDeleteStore({required this.parentKey});
}
