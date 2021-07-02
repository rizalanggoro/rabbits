import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rabbits/bloc/rabbit_parent/rabbit_parent_event.dart';
import 'package:rabbits/bloc/rabbit_parent/rabbit_parent_state.dart';
import 'package:rabbits/database/rabbit_parent_database.dart';
import 'package:rabbits/model/rabbit_parent_model.dart';
import 'package:sembast/sembast.dart';

class RabbitParentBloc extends Bloc<RabbitParentEvent, RabbitParentState> {
  RabbitParentBloc() : super(OnInitial());
  final StoreRef _storeRef = StoreRef('rabbit-parent');

  @override
  Stream<RabbitParentState> mapEventToState(RabbitParentEvent event) async* {
    if (event is GetAllRabbitParent) {
      //* get all rabbit parent from database
      yield OnLoading();
      yield* _getAllRabbitParent();
    } else if (event is AddRabbitParent) {
      //* add rabbit parent model to database
      yield OnLoading();
      yield* _addRabbitParent(event.rabbitParentModel);
    } else if (event is ResetToInitial) {
      //* reset state to initial
      yield OnInitial();
    } else if (event is GetRabbitParentByKey) {
      //* get rabbit parent model by key
      yield OnLoading();
      yield* _getRabbitParentByKey(event.parentKey);
    } else if (event is ChangeRabbitParentMarryDate) {
      //* change rabbit parent marry date
      yield OnLoading();
      yield* _changeRabbitParentMarryDate(
        event.parentKey,
        event.marryDateTime,
      );
    } else if (event is DeleteDatabaseRabbitParent) {
      //* delete rabbit parent database
      yield OnLoading();
      var _a = RabbitParentDatabase();
      var _b = await _a.openDatabase();
      await _storeRef.delete(_b);
    } else if (event is ChangeRabbitParentStatus) {
      //* change rabbit parent status
      yield OnLoading();

      var _a = {RabbitParentModel.statusKey: event.parentStatus};
      var _b = await _openDatabase();

      //* put data to database
      await _storeRef.record(event.parentKey).put(_b, _a, merge: true);
      yield OnChangeRabbitParentStatus(
        parentKey: event.parentKey,
        parentStatus: event.parentStatus,
      );
    } else if (event is ChangeRabbitParentName) {
      //* change rabbit parent name
      yield OnLoading();

      var _a = {RabbitParentModel.parentNameKey: event.parentName};
      var _b = await _openDatabase();

      //* put data into database
      await _storeRef.record(event.parentKey).put(_b, _a, merge: true);
      yield OnChangeRabbitParentName(
        parentKey: event.parentKey,
        parentName: event.parentName,
      );
    } else if (event is ResetRabbitParentToZero) {
      //* reset rabbit parent to zero
      yield OnLoading();

      var _a = RabbitParentModel(
        key: event.parentKey,
        parentName: event.parentName,
        marryDate: '',
        status: '',
      );
      var _b = await _openDatabase();

      //* put new data to database
      await _storeRef.record(event.parentKey).put(
            _b,
            _a.toMap(),
            merge: true,
          );
      yield OnResetRabbitParent(parentKey: event.parentKey);
    } else if (event is DeleteRabbitParentFromDatabase) {
      //* delete rabbit parent from database
      //* delete rabbit parent born history from database too
      yield OnLoading();

      var _parentKey = event.parentKey;
      var _a = await _openDatabase();
      await _storeRef.record(_parentKey).delete(_a);
      yield OnDeleteRabbitParentFromDatabase(parentKey: _parentKey);
    }
  }

  Future<Database> _openDatabase() async {
    var _a = RabbitParentDatabase();
    return await _a.openDatabase();
  }

  Stream<RabbitParentState> _changeRabbitParentMarryDate(
      String parentKey, String marryDateTime) async* {
    var _a = RabbitParentDatabase();
    var _b = await _a.openDatabase();
    var _c = {'d': marryDateTime};
    await _storeRef.record(parentKey).put(_b, _c, merge: true);
    yield OnChangeRabbitParentMarryDate(
      parentKey: parentKey,
      marryDateTime: marryDateTime,
    );
  }

  Stream<RabbitParentState> _getRabbitParentByKey(String parentKey) async* {
    var _a = RabbitParentDatabase();
    var _b = await _a.openDatabase();
    var _c = await _storeRef.record(parentKey).get(_b);
    var _d = RabbitParentModel.fromJson(_c);
    yield OnGetRabbitParentByKey(rabbitParentModel: _d);
  }

  Stream<RabbitParentState> _addRabbitParent(
      RabbitParentModel rabbitParentModel) async* {
    var _a = RabbitParentDatabase();
    var _b = await _a.openDatabase();
    await _storeRef
        .record(rabbitParentModel.key)
        .put(_b, rabbitParentModel.toMap(), merge: true);
    yield OnAddedRabbitParent(rabbitParentModel: rabbitParentModel);
  }

  Stream<RabbitParentState> _getAllRabbitParent() async* {
    var _a = RabbitParentDatabase();
    var _b = await _a.openDatabase();
    var _c = await _storeRef.find(_b);

    List<RabbitParentModel> _d = [];
    List<String> _e = [];
    for (var element in _c) {
      var _f = RabbitParentModel.fromJson(element.value);
      _d.add(_f);
      _e.add(_f.key!);
    }
    _d.sort((a, b) => a.key!.compareTo(b.key!));
    _e.sort();
    yield OnGetAllRabbitParentCompleted(
        listRabbitParentModel: _d, listRabbitParentKey: _e);
  }
}
