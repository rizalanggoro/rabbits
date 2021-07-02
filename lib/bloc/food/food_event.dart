part of 'food_bloc.dart';

@immutable
abstract class FoodEvent {}

class FoodResetToInitial extends FoodEvent {}

class FoodAdd extends FoodEvent {
  final FoodModel foodModel;
  FoodAdd({required this.foodModel});
}

class FoodGetAll extends FoodEvent {}

class FoodDelete extends FoodEvent {
  final String foodKey;
  FoodDelete({required this.foodKey});
}

class FoodUpdate extends FoodEvent {
  final FoodModel foodModel;
  FoodUpdate({required this.foodModel});
}
