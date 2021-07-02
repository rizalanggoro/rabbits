part of 'a_child_bloc.dart';

@immutable
abstract class AChildState {}

class AChildInitial extends AChildState {}

class AChildOnAdd extends AChildState {
  final AChildModel childModel;
  AChildOnAdd({required this.childModel});
}

class AChildOnChangeBornDate extends AChildState {
  final String childKey;
  final String bornDate;
  AChildOnChangeBornDate({
    required this.childKey,
    required this.bornDate,
  });
}

class AChildOnChangeIndex extends AChildState {}

class AChildOnChangeWeight extends AChildState {
  final String childKey;
  final String childWeight;
  AChildOnChangeWeight({
    required this.childKey,
    required this.childWeight,
  });
}

class AChildOnChangeFoodMap extends AChildState {
  final String childKey;
  final String childFoodMap;
  AChildOnChangeFoodMap({
    required this.childKey,
    required this.childFoodMap,
  });
}

class AChildOnResetData extends AChildState {
  final String childKey;
  final String childName;
  AChildOnResetData({
    required this.childKey,
    required this.childName,
  });
}

class AChildOnDeleteData extends AChildState {
  final String childKey;
  AChildOnDeleteData({required this.childKey});
}

class AChildOnChangeName extends AChildState {
  final String childKey;
  final String childName;
  AChildOnChangeName({
    required this.childKey,
    required this.childName,
  });
}
