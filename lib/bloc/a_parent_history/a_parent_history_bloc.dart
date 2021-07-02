import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rabbits/database/a_parent_history_database.dart';
import 'package:rabbits/model/a_parent_history_model.dart';
import 'package:sembast/sembast.dart';

part 'a_parent_history_event.dart';
part 'a_parent_history_state.dart';

class AParentHistoryBloc
    extends Bloc<AParentHistoryEvent, AParentHistoryState> {
  AParentHistoryBloc() : super(AParentHistoryInitial());

  @override
  Stream<AParentHistoryState> mapEventToState(
    AParentHistoryEvent event,
  ) async* {
    if (event is AParentHistoryResetInitial) {
      yield AParentHistoryInitial();
    } else if (event is AParentHistoryAdd) {
      // add parent history model to database
      var _database = AParentHistoryDatabase();
      var _client = await _database.openDatabase();
      var _model = event.parentHistoryModel;

      await _getStoreRef(_model.parentKey!).record(_model.key!).put(
            _client,
            _model.toMap(),
            merge: true,
          );
      yield AParentHistoryOnAdd(parentHistoryModel: _model);
    } else if (event is AParentHistoryDelete) {
      // delete history model from database
      var _database = AParentHistoryDatabase();
      var _client = await _database.openDatabase();
      var _parentKey = event.parentKey;
      var _historyKey = event.historyKey;

      await _getStoreRef(_parentKey).record(_historyKey).delete(_client);
      yield AParentHistoryOnDelete(
        parentKey: _parentKey,
        historyKey: _historyKey,
      );
    } else if (event is AParentHistoryDeleteStore) {
      // delete history store
      var _database = AParentHistoryDatabase();
      var _client = await _database.openDatabase();
      var _parentKey = event.parentKey;
      await _getStoreRef(_parentKey).delete(_client);
      yield AParentHistoryOnDeleteStore(parentKey: _parentKey);
    }
  }

  StoreRef _getStoreRef(String parentKey) =>
      StoreRef('a-parent-history-$parentKey-ref');

  static const listHistoryKeyKey = 'a';
  static const listHistoryModelKey = 'b';
  Future<Map<String, dynamic>> getAll({required String parentKey}) async {
    // get all parent history from database
    var _database = AParentHistoryDatabase();
    var _client = await _database.openDatabase();

    List<String> _listKey = [];
    List<AParentHistoryModel> _listModel = [];

    var _result = await _getStoreRef(parentKey).find(_client);
    _result.sort((a, b) => b.key.compareTo(a.key));
    for (var _item in _result) {
      var _model = AParentHistoryModel.fromMap(_item.value);
      _listKey.add(_model.key!);
      _listModel.add(_model);
    }

    return {
      listHistoryKeyKey: _listKey,
      listHistoryModelKey: _listModel,
    };
  }
}
