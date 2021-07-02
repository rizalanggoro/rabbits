import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rabbits/database/a_parent_database.dart';
import 'package:rabbits/model/a_parent_model.dart';
import 'package:sembast/sembast.dart';

part 'a_parent_event.dart';
part 'a_parent_state.dart';

class AParentBloc extends Bloc<AParentEvent, AParentState> {
  AParentBloc() : super(AParentInitial());

  final StoreRef _storeRef = StoreRef('a-parent');

  @override
  Stream<AParentState> mapEventToState(AParentEvent event) async* {
    if (event is AParentResetToInitial) {
      yield AParentInitial();
    } else if (event is AParentAdd) {
      // add parent model to database
      var _database = AParentDatabase();
      var _client = await _database.openDatabase();
      var _model = event.aParentModel;

      await _storeRef
          .record(_model.parentKey!)
          .put(_client, _model.toMap(), merge: true);
      yield AParentOnAdd(aParentModel: _model);
    } else if (event is AParentChangeName) {
      // change parent name
      var _parentKey = event.parentKey;
      var _parentName = event.parentName;

      await _change(
        _parentKey,
        AParentModel.parentNameKey,
        _parentName,
      );
      yield AParentOnChangeName(
        parentKey: _parentKey,
        parentName: _parentName,
      );
    } else if (event is AParentChangeMarryDate) {
      // change parent marry date
      var _parentKey = event.parentKey;
      var _parentMarryDate = event.parentMarryDate;
      await _change(
        _parentKey,
        AParentModel.parentMarryDateKey,
        _parentMarryDate,
      );
      yield AParentOnChangeMarryDate(
        parentKey: _parentKey,
        parentMarryDate: _parentMarryDate,
      );
    } else if (event is AParentChangeStatus) {
      // change parent status
      var _parentKey = event.parentKey;
      var _parentStatus = event.parentStatus;
      await _change(
        _parentKey,
        AParentModel.parentStatusKey,
        _parentStatus,
      );
      yield AParentOnChangeStatus(
        parentKey: _parentKey,
        parentStatus: _parentStatus,
      );
    } else if (event is AParentResetData) {
      // reset parent data to zero
      var _database = AParentDatabase();
      var _client = await _database.openDatabase();

      var _parentKey = event.parentKey;
      var _parentName = event.parentName;
      var _parentModel = AParentModel(
        parentKey: _parentKey,
        parentName: _parentName,
        parentMarryDate: '',
        parentStatus: '',
      );
      await _storeRef.record(_parentKey).put(
            _client,
            _parentModel.toMap(),
            merge: true,
          );
      yield AParentOnResetData();
    } else if (event is AParentDeleteRecord) {
      // delete parent model from database
      var _database = AParentDatabase();
      var _client = await _database.openDatabase();
      var _parentKey = event.parentKey;

      await _storeRef.record(_parentKey).delete(_client);
      yield AParentOnDeleteRecord(parentKey: _parentKey);
    }
  }

  Future _change(String parentKey, String key, String value) async {
    var _database = AParentDatabase();
    var _client = await _database.openDatabase();
    return await _storeRef
        .record(parentKey)
        .put(_client, {key: value}, merge: true);
  }

  static const listParentKeyKey = 'a';
  static const listParentModelKey = 'b';
  static const listPregnantParentKeyKey = 'c';
  static const listPregnantParentModelKey = 'd';
  Future<Map<String, dynamic>> getAll() async {
    var _database = AParentDatabase();
    var _client = await _database.openDatabase();
    var _result = await _storeRef.find(_client);

    List<String> _listParentKey = [];
    List<AParentModel> _listParentModel = [];
    List<String> _listPregnantParentKey = [];
    List<AParentModel> _listPregnantParentModel = [];
    for (var _data in _result) {
      var _model = AParentModel.fromMap(_data.value);
      if (_model.parentStatus!.isNotEmpty) {
        // pregnant
        _listPregnantParentKey.add(_model.parentKey!);
        _listPregnantParentModel.add(_model);
      } else {
        _listParentKey.add(_model.parentKey!);
        _listParentModel.add(_model);
      }
    }

    return {
      listParentKeyKey: _listParentKey,
      listParentModelKey: _listParentModel,
      listPregnantParentKeyKey: _listPregnantParentKey,
      listPregnantParentModelKey: _listPregnantParentModel,
    };
  }
}
