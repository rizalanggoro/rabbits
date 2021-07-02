part of 'a_parent_bloc.dart';

@immutable
abstract class AParentEvent {}

class AParentResetToInitial extends AParentEvent {}

class AParentAdd extends AParentEvent {
  final AParentModel aParentModel;
  AParentAdd({required this.aParentModel});
}

class AParentChangeName extends AParentEvent {
  final String parentKey;
  final String parentName;
  AParentChangeName({
    required this.parentKey,
    required this.parentName,
  });
}

class AParentChangeMarryDate extends AParentEvent {
  final String parentKey;
  final String parentMarryDate;
  AParentChangeMarryDate({
    required this.parentKey,
    required this.parentMarryDate,
  });
}

class AParentChangeStatus extends AParentEvent {
  final String parentKey;
  final String parentStatus;
  AParentChangeStatus({
    required this.parentKey,
    required this.parentStatus,
  });
}

class AParentResetData extends AParentEvent {
  final String parentKey;
  final String parentName;
  AParentResetData({
    required this.parentKey,
    required this.parentName,
  });
}

class AParentDeleteRecord extends AParentEvent {
  final String parentKey;
  AParentDeleteRecord({required this.parentKey});
}
