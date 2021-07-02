part of 'a_parent_bloc.dart';

@immutable
abstract class AParentState {}

class AParentInitial extends AParentState {}

class AParentOnAdd extends AParentState {
  final AParentModel aParentModel;
  AParentOnAdd({required this.aParentModel});
}

class AParentOnChangeName extends AParentState {
  final String parentKey;
  final String parentName;
  AParentOnChangeName({
    required this.parentKey,
    required this.parentName,
  });
}

class AParentOnChangeMarryDate extends AParentState {
  final String parentKey;
  final String parentMarryDate;
  AParentOnChangeMarryDate({
    required this.parentKey,
    required this.parentMarryDate,
  });
}

class AParentOnChangeStatus extends AParentState {
  final String parentKey;
  final String parentStatus;
  AParentOnChangeStatus({
    required this.parentKey,
    required this.parentStatus,
  });
}

class AParentOnResetData extends AParentState {}

class AParentOnDeleteRecord extends AParentState {
  final String parentKey;
  AParentOnDeleteRecord({required this.parentKey});
}
