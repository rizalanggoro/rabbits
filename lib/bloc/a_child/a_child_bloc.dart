import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rabbits/database/a_child_database.dart';
import 'package:rabbits/model/a_child_model.dart';
import 'package:sembast/sembast.dart';

part 'a_child_event.dart';
part 'a_child_state.dart';

class AChildBloc extends Bloc<AChildEvent, AChildState> {
  AChildBloc() : super(AChildInitial());

  final StoreRef _storeRef = StoreRef('a-child-ref');
  @override
  Stream<AChildState> mapEventToState(AChildEvent event) async* {
    if (event is AChildResetInitial) {
      yield AChildInitial();
    } else if (event is AChildAdd) {
      // add child model to database
      var _database = AChildDatabase();
      var _client = await _database.openDatabase();

      var _model = event.childModel;
      await _storeRef.record(_model.childKey!).put(_client, _model.toMap());
      yield AChildOnAdd(childModel: _model);
    } else if (event is AChildChangeBornDate) {
      // change child born date
      var _client = await _getClient();
      await _storeRef.record(event.childKey).put(
          _client, {AChildModel.childBornDateKey: event.bornDate},
          merge: true);
      yield AChildOnChangeBornDate(
        childKey: event.childKey,
        bornDate: event.bornDate,
      );
    } else if (event is AChildChangeIndex) {
      yield AChildOnChangeIndex();
    } else if (event is AChildChangeWeight) {
      // change child weight
      var _client = await _getClient();
      await _storeRef.record(event.childKey).put(
            _client,
            {AChildModel.childWeightKey: event.childWeight},
            merge: true,
          );
      yield AChildOnChangeWeight(
        childKey: event.childKey,
        childWeight: event.childWeight,
      );
    } else if (event is AChildChangeFoodMap) {
      // change child food map
      var _client = await _getClient();
      var _value = {
        AChildModel.childFoodMapKey: event.childFoodMap,
      };
      await _storeRef.record(event.childKey).put(_client, _value, merge: true);
      yield AChildOnChangeFoodMap(
        childKey: event.childKey,
        childFoodMap: event.childFoodMap,
      );
    } else if (event is AChildResetData) {
      // reset child data to zero
      var _client = await _getClient();
      var _model = AChildModel(
        childKey: event.childKey,
        childBornDate: DateTime.now().toString(),
        childFoodMap: '{}',
        childName: event.childName,
        childWeight: '0',
      );
      await _storeRef.record(event.childKey).put(
            _client,
            _model.toMap(),
            merge: true,
          );
      yield AChildOnResetData(
        childKey: event.childKey,
        childName: event.childKey,
      );
    } else if (event is AChildDeleteData) {
      // delete child from database
      var _client = await _getClient();
      await _storeRef.record(event.childKey).delete(_client);
      yield AChildOnDeleteData(childKey: event.childKey);
    } else if (event is AChildChangeName) {
      // change child name
      var _client = await _getClient();
      var _value = {
        AChildModel.childNameKey: event.childName,
      };
      await _storeRef.record(event.childKey).put(_client, _value, merge: true);
      yield AChildOnChangeName(
        childKey: event.childKey,
        childName: event.childName,
      );
    }
  }

  Future<Database> _getClient() async {
    var _database = AChildDatabase();
    var _client = await _database.openDatabase();
    return _client;
  }

  static const listChildKeyKey = 'a';
  static const listChildModelKey = 'b';
  Future<Map<String, dynamic>> getAll() async {
    var _database = AChildDatabase();
    var _client = await _database.openDatabase();

    List<String> _listKey = [];
    List<AChildModel> _listModel = [];

    var _result = await _storeRef.find(_client);
    _result.sort((a, b) => a.key.compareTo(b.key));
    for (var _item in _result) {
      var _model = AChildModel.fromMap(_item.value);
      _listKey.add(_model.childKey!);
      _listModel.add(_model);
    }

    return {
      listChildKeyKey: _listKey,
      listChildModelKey: _listModel,
    };
  }
}
