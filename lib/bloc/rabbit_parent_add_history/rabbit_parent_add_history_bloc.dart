import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rabbits/bloc/rabbit_parent_add_history/rabbit_parent_add_history_event.dart';
import 'package:rabbits/bloc/rabbit_parent_add_history/rabbit_parent_add_history_state.dart';
import 'package:rabbits/database/rabbit_parent_history_database.dart';
import 'package:rabbits/model/rabbit_parent_history_model.dart';
import 'package:sembast/sembast.dart';

class RabbitParentAddHistoryBloc
    extends Bloc<RabbitParentAddHistoryEvent, RabbitParentAddHistoryState> {
  RabbitParentAddHistoryBloc() : super(OnInitial());

  @override
  Stream<RabbitParentAddHistoryState> mapEventToState(
      RabbitParentAddHistoryEvent event) async* {
    if (event is RabbitParentHistoryChangeBornDate) {
      // event change rabbit parent born date time
      yield OnLoading();
      yield OnChangeRabbitParentHistoryBornDate(
          dateTimeBorn: event.dateTimeBorn);
    } else if (event is RabbitParentHistoryChangeChildCount) {
      // event change rabbit parent child count
      yield OnLoading();
      yield OnChangeRabbitParentHistoryChildCount(childCount: event.childCount);
    } else if (event is RabbitParentHistoryResetDefaultValue) {
      yield OnResetDefaultValueRabbitParentHistory();
    } else if (event is RabbitParentHistoryAddModel) {
      // event add rabbit parent history to database
      yield OnLoading();

      var _parentKey = event.parentKey;
      var _model = event.rabbitParentHistoryModel;
      var _mapModel = _model.toMap();

      var _storeRef = StoreRef('rabbit-parent-history-${_parentKey.trim()}');
      var _database = RabbitParentHistoryDatabase();
      var _client = await _database.openDatabase();

      await _storeRef.record(_model.key).put(_client, _mapModel, merge: true);
      yield OnAddedRabbitParentHistory(
        parentKey: _parentKey,
        rabbitParentHistoryModel: _model,
      );
    } else if (event is GetAllRabbitParentHistory) {
      // event get all rabbit parent history from database
      yield OnLoading();

      var _parentKey = event.parentKey;
      var _storeRef = StoreRef('rabbit-parent-history-${_parentKey.trim()}');
      var _database = RabbitParentHistoryDatabase();
      var _client = await _database.openDatabase();

      List<String> _listKey = [];
      List<RabbitParentHistoryModel> _listModel = [];

      var _result = await _storeRef.find(_client);
      _result.sort((a, b) => b.key.compareTo(a.key));
      for (var element in _result) {
        var _model = RabbitParentHistoryModel.fromMap(element.value);
        _listKey.add(_model.key!);
        _listModel.add(_model);
      }

      yield OnGetAllRabbitParentHistory(
        parentKey: _parentKey,
        listRabbitParentHistoryKey: _listKey,
        listRabbitParentHistoryModel: _listModel,
      );
    } else if (event is DeleteRabbitParentHistory) {
      // event delete rabbit parent history from database
      yield OnLoading();

      var _parentKey = event.parentKey;
      var _storeRef = StoreRef('rabbit-parent-history-${_parentKey.trim()}');
      var _database = RabbitParentHistoryDatabase();
      var _client = await _database.openDatabase();

      await _storeRef.record(event.historyKey).delete(_client);
      yield OnDeleteRabbitParentHistory(historyKey: event.historyKey);
    } else if (event is DeleteRabbitHistoryStoreRef) {
      // event delete rabbit parent history store ref
      yield OnLoading();

      var _parentKey = event.parentKey;
      var _storeRef = StoreRef('rabbit-parent-history-${_parentKey.trim()}');
      var _database = RabbitParentHistoryDatabase();
      var _client = await _database.openDatabase();

      await _storeRef.delete(_client);
    }
  }
}
