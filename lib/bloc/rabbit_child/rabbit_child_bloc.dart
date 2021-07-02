import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rabbits/bloc/rabbit_child/rabbit_child_event.dart';
import 'package:rabbits/bloc/rabbit_child/rabbit_child_state.dart';
import 'package:rabbits/database/rabbit_child_database.dart';
import 'package:rabbits/model/rabbit_child_model.dart';
import 'package:sembast/sembast.dart';

class RabbitChildBloc extends Bloc<RabbitChildEvent, RabbitChildState> {
  RabbitChildBloc() : super(Initial());

  @override
  Stream<RabbitChildState> mapEventToState(RabbitChildEvent event) async* {
    if (event is Add) {
      yield OnLoading();
      yield* _addRabbitChild(event.rabbitChildModel);
    } else if (event is ResetToInitial) {
      yield Initial();
    } else if (event is GetAllRabbits) {
      yield OnLoading();
      yield* _getAllRabbits();
    } else if (event is GetRabbitByKey) {
      yield OnLoading();
      yield* _getRabbitByKey(event.rabbitKey);
    } else if (event is DeleteAllDatabase) {
      yield* _deleteAllDatabase();
    } else if (event is IncrementFood) {
      yield OnLoading();
      yield* _updateFood(event.rabbitKey, true);
    } else if (event is DecrementFood) {
      yield* _updateFood(event.rabbitKey, false);
    } else if (event is ChangePetBorn) {
      //? change pet born
      yield OnLoading();
      yield* _changePetBorn(event.rabbitKey, event.stringDateTime);
    } else if (event is ChangePetWeight) {
      //? change pet weight
      yield OnLoading();
      yield* _changePetWeight(event.rabbitKey, event.petWeight);
    } else if (event is ChangeHomeName) {
      //? change home name
      yield OnLoading();
      yield* _changeHomeName(event.rabbitKey, event.homeName);
    } else if (event is ResetToZero) {
      //? reset rabbit data to zero
      yield OnLoading();
      yield* _resetToZero(event.rabbitKey, event.homeName);
    } else if (event is DeleteRabbit) {
      //? delete rabbit from database event
      yield OnLoading();
      yield* _deleteRabbit(event.rabbitKey);
    }
  }

  Stream<RabbitChildState> _deleteRabbit(String rabbitKey) async* {
    var _a = RabbitChildDatabase();
    var _b = await _a.openDatabase();
    await _storeRef.record(rabbitKey).delete(_b);
    yield OnDeletedRabbit(rabbitKey: rabbitKey);
  }

  Stream<RabbitChildState> _resetToZero(
      String rabbitKey, String homeName) async* {
    var _a = RabbitChildDatabase();
    var _b = await _a.openDatabase();
    var _c = RabbitChildModel(
            key: rabbitKey,
            petWeight: '0',
            petBorn: DateTime.now().toString(),
            foodCount: '0',
            homeName: homeName)
        .toJson();
    await _storeRef.record(rabbitKey).put(_b, _c, merge: true);
    yield OnResetToZeroCompleted(
      rabbitKey: rabbitKey,
      rabbitChildModel: RabbitChildModel.fromJson(_c),
    );
  }

  Stream<RabbitChildState> _changeHomeName(
      String rabbitKey, String homeName) async* {
    var _a = RabbitChildDatabase();
    var _b = await _a.openDatabase();
    await _storeRef
        .record(rabbitKey)
        .put(_b, {'homeName': homeName}, merge: true);
    yield OnChangeHomeName(rabbitKey: rabbitKey, homeName: homeName);
  }

  Stream<RabbitChildState> _changePetWeight(
      String rabbitKey, String petWeight) async* {
    var _a = RabbitChildDatabase();
    var _b = await _a.openDatabase();
    await _storeRef
        .record(rabbitKey)
        .put(_b, {'petWeight': petWeight}, merge: true);
    yield OnChangePetWeight(rabbitKey: rabbitKey, petWeight: petWeight);
  }

  Stream<RabbitChildState> _changePetBorn(
      String rabbitKey, String stringDateTime) async* {
    var _a = RabbitChildDatabase();
    var _b = await _a.openDatabase();
    await _storeRef
        .record(rabbitKey)
        .put(_b, {'petBorn': stringDateTime}, merge: true);
    yield OnChangePetBorn(rabbitKey: rabbitKey, stringDateTime: stringDateTime);
  }

  Stream<RabbitChildState> _updateFood(
      String rabbitKey, bool isIncrement) async* {
    var _a = RabbitChildDatabase();
    var _b = await _a.openDatabase();
    var _c = await _storeRef.record(rabbitKey).get(_b);
    var _d = RabbitChildModel.fromJson(_c).foodCount;
    var _e = 0;
    if (_d == null) {
      _e = 0;
    } else {
      _e = int.parse(_d);
    }
    //? increment food count
    if (isIncrement) {
      _e++;
    } else {
      _e--;
    }
    //? update food count to database
    await _storeRef
        .record(rabbitKey)
        .put(_b, {'foodCount': '$_e'}, merge: true);
    yield isIncrement
        ? OnIncrementFood(foodCount: '$_e', rabbitKey: rabbitKey)
        : OnDecrementFood(foodCount: '$_e', rabbitKey: rabbitKey);
  }

  Stream<RabbitChildState> _deleteAllDatabase() async* {
    var _a = RabbitChildDatabase();
    var _b = await _a.openDatabase();
    await _storeRef.delete(_b);
    yield OnDeleteDatabaseSuccess();
  }

  final StoreRef _storeRef = StoreRef('rabbit-child');
  Stream<RabbitChildState> _getRabbitByKey(String key) async* {
    var _a = RabbitChildDatabase();
    var _b = await _a.openDatabase();
    var _c = await _storeRef.record(key).get(_b);
    var _d = RabbitChildModel.fromJson(_c);
    yield OnGetByKeyCompleted(rabbitChildModel: _d);
  }

  Stream<RabbitChildState> _addRabbitChild(
      RabbitChildModel rabbitChildModel) async* {
    var _a = RabbitChildDatabase();
    var _b = await _a.openDatabase();
    await _storeRef
        .record(rabbitChildModel.key)
        .put(_b, rabbitChildModel.toJson(), merge: true);
    yield OnAdd(rabbitChildModel: rabbitChildModel);
  }

  Stream<RabbitChildState> _getAllRabbits() async* {
    var _a = RabbitChildDatabase();
    var _b = await _a.openDatabase();
    var _c = await _storeRef.find(_b);

    List<RabbitChildModel> _d = [];
    List<String> _e = [];
    for (var element in _c) {
      var _f = RabbitChildModel.fromJson(element.value);
      _d.add(_f);
      _e.add(_f.key!);
    }
    _d.sort((a, b) => a.key!.compareTo(b.key!));
    yield OnGetAllCompleted(listRabbitChild: _d, listRabbitChildKey: _e);
  }
}
