import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:rabbits/database/food_database.dart';
import 'package:rabbits/model/food_model.dart';
import 'package:sembast/sembast.dart';

part 'food_event.dart';
part 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  FoodBloc() : super(FoodInitial());

  final StoreRef _storeRef = StoreRef('food-ref');

  @override
  Stream<FoodState> mapEventToState(FoodEvent event) async* {
    if (event is FoodResetToInitial) {
      yield FoodInitial();
    } else if (event is FoodAdd) {
      // add food model to database
      var _database = FoodDatabase();
      var _client = await _database.openDatabase();
      var _model = event.foodModel;
      await _storeRef.record(_model.key).put(_client, _model.toMap());
      yield FoodOnAdd(foodModel: _model);
    } else if (event is FoodUpdate) {
      // add food model to database
      var _database = FoodDatabase();
      var _client = await _database.openDatabase();
      var _model = event.foodModel;
      await _storeRef.record(_model.key).put(_client, _model.toMap());
      yield FoodOnUpdate(foodModel: _model);
    } else if (event is FoodGetAll) {
      // get all food from database
      var _database = FoodDatabase();
      var _client = await _database.openDatabase();

      var _result = await _storeRef.find(_client);
      _result.sort((a, b) => a.key.compareTo(b.key));

      List<String> _listKey = [];
      List<FoodModel> _listModel = [];
      for (var _a in _result) {
        var _b = FoodModel.fromMap(_a.value);
        _listKey.add(_b.key!);
        _listModel.add(_b);
      }
      yield FoodOnGetAll(
        listFoodKey: _listKey,
        listFoodModel: _listModel,
      );
    } else if (event is FoodDelete) {
      // delete food by key from database
      var _database = FoodDatabase();
      var _client = await _database.openDatabase();

      await _storeRef.record(event.foodKey).delete(_client);
      yield FoodOnDeleted(foodKey: event.foodKey);
    }
  }

  Future<Map<String, dynamic>> getAll() async {
    // get all food from database
    var _database = FoodDatabase();
    var _client = await _database.openDatabase();

    var _result = await _storeRef.find(_client);
    _result.sort((a, b) => a.key.compareTo(b.key));

    List<String> _listKey = [];
    List<FoodModel> _listModel = [];
    for (var _a in _result) {
      var _b = FoodModel.fromMap(_a.value);
      _listKey.add(_b.key!);
      _listModel.add(_b);
    }

    var _map = {
      'key': _listKey,
      'model': _listModel,
    };
    return _map;
  }
}
