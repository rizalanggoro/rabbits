part of 'food_bloc.dart';

@immutable
abstract class FoodState {}

class FoodInitial extends FoodState {}

class FoodOnAdd extends FoodState {
  final FoodModel foodModel;
  FoodOnAdd({required this.foodModel});
}

class FoodOnGetAll extends FoodState {
  final List<String> listFoodKey;
  final List<FoodModel> listFoodModel;
  FoodOnGetAll({required this.listFoodKey, required this.listFoodModel});
}

class FoodOnDeleted extends FoodState {
  final String foodKey;
  FoodOnDeleted({required this.foodKey});
}

class FoodOnUpdate extends FoodState {
  final FoodModel foodModel;
  FoodOnUpdate({required this.foodModel});
}
