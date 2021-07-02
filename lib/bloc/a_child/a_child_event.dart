part of 'a_child_bloc.dart';

@immutable
abstract class AChildEvent {}

class AChildResetInitial extends AChildEvent {}

class AChildAdd extends AChildEvent {
  final AChildModel childModel;
  AChildAdd({required this.childModel});
}

class AChildChangeBornDate extends AChildEvent {
  final String childKey;
  final String bornDate;
  AChildChangeBornDate({
    required this.childKey,
    required this.bornDate,
  });
}

class AChildChangeIndex extends AChildEvent {}

class AChildChangeWeight extends AChildEvent {
  final String childKey;
  final String childWeight;
  AChildChangeWeight({required this.childKey, required this.childWeight});
}

class AChildChangeFoodMap extends AChildEvent {
  final String childKey;
  final String childFoodMap;
  AChildChangeFoodMap({
    required this.childKey,
    required this.childFoodMap,
  });
}

class AChildResetData extends AChildEvent {
  final String childKey;
  final String childName;
  AChildResetData({
    required this.childKey,
    required this.childName,
  });
}

class AChildDeleteData extends AChildEvent {
  final String childKey;
  AChildDeleteData({required this.childKey});
}

class AChildChangeName extends AChildEvent {
  final String childKey;
  final String childName;
  AChildChangeName({
    required this.childKey,
    required this.childName,
  });
}
