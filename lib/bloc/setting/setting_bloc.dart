import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rabbits/bloc/setting/setting_event.dart';
import 'package:rabbits/bloc/setting/setting_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(Initial());

  @override
  Stream<SettingState> mapEventToState(SettingEvent event) async* {
    if (event is LoadFoodUnit) {
      yield OnLoading();
      yield* _loadFoodUnit();
    } else if (event is LoadWeightUnit) {
      yield OnLoading();
      yield* _loadWeightUnit();
    } else if (event is LoadFoodPrice) {
      yield OnLoading();
      yield* _loadFoodPrice();
    } else if (event is LoadPetPrice) {
      yield OnLoading();
      yield* _loadPetPrice();
    } else if (event is LoadFoodWeight) {
      yield OnLoading();
      yield* _loadFoodWeight();
    }

    if (event is ChangeFoodUnit) {
      yield OnLoading();
      yield* _changeFoodUnit(event.foodUnit);
    } else if (event is ChangeWeightUnit) {
      yield OnLoading();
      yield* _changeWeightUnit(event.weightUnit);
    } else if (event is ChangeFoodPrice) {
      yield OnLoading();
      yield* _changeFoodPrice(event.foodPrice);
    } else if (event is ChangePetPrice) {
      yield OnLoading();
      yield* _changePetPrice(event.petPrice);
    } else if (event is ChangeFoodWeight) {
      yield OnLoading();
      yield* _changeFoodWeight(event.foodWeight);
    } else if (event is ChangeRabbitParentEstimateBorn) {
      //* change rabbit parent estimate born
      var _a = event.rabbitParentEstimateBorn;
      yield OnLoading();
      await _changeDatabase(rabbitParentEstimateBornKey, _a);
      yield OnChangeRabbitParentEstimateBorn(rabbitParentEstimateBorn: _a);
    } else if (event is ChangeRabbitParentAddBox) {
      //* change rabbit parent add box
      var _a = event.rabbitParentAddBox;
      yield OnLoading();

      //* put data in database
      await _changeDatabase(rabbitParentAddBoxKey, _a);
      yield OnChangeRabbitParentAddBox(rabbitParentAddBox: _a);
    }

    if (event is ResetToInitial) {
      yield Initial();
    } else if (event is GetAllSetting) {
      yield OnLoading();
      yield* _getAllSetting();
    }
  }

  //* keys
  static const foodUnitKey = 'food-unit-bloc';
  static const weightUnitKey = 'weight-unit-bloc';
  static const foodPriceKey = 'food-price-bloc';
  static const petPriceKey = 'pet-price-bloc';
  static const foodWeightKey = 'food-weight-bloc';
  static const rabbitParentEstimateBornKey = 'setting-f';
  static const rabbitParentAddBoxKey = 'setting-g';

  static final keys = [
    foodUnitKey,
    weightUnitKey,
    foodPriceKey,
    petPriceKey,
    foodWeightKey,
  ];

  // * ---------------------------------------------------------------
  // * get all setting event
  // * ---------------------------------------------------------------
  Stream<SettingState> _getAllSetting() async* {
    var _a = await SharedPreferences.getInstance();
    var _b = {
      keys[0]: _a.getString(keys[0]) ?? '0',
      keys[1]: _a.getString(keys[1]) ?? '0',
      keys[2]: _a.getString(keys[2]) ?? '0',
      keys[3]: _a.getString(keys[3]) ?? '0',
      keys[4]: _a.getString(keys[4]) ?? '0',
      rabbitParentEstimateBornKey:
          _a.getString(rabbitParentEstimateBornKey) ?? '0',
      rabbitParentAddBoxKey: _a.getString(rabbitParentAddBoxKey) ?? '0',
    };
    yield OnGetAllSettingCompleted(map: _b);
  }

  // * ---------------------------------------------------------------
  // * update event
  // * ---------------------------------------------------------------
  Future<bool> _changeDatabase(String key, String value) async {
    var _a = await SharedPreferences.getInstance();
    return _a.setString(key, value);
  }

  // Stream<SettingState> _changeRabbitParentEstimateBorn(
  //     String rabbitParentEstimateBorn) async* {
  //   var _a = await SharedPreferences.getInstance();
  //   await _a.setString(rabbitParentEstimateBornKey, rabbitParentEstimateBorn);
  //   yield OnChangeRabbitParentEstimateBorn(
  //     rabbitParentEstimateBorn: rabbitParentEstimateBorn,
  //   );
  // }

  Stream<SettingState> _changeFoodUnit(String foodUnit) async* {
    var _a = await SharedPreferences.getInstance();
    await _a.setString(keys[0], foodUnit);
    yield OnChangeFoodUnit(foodUnit: foodUnit);
  }

  Stream<SettingState> _changeWeightUnit(String weightUnit) async* {
    var _a = await SharedPreferences.getInstance();
    await _a.setString(keys[1], weightUnit);
    yield OnChangeWeightUnit(weightUnit: weightUnit);
  }

  Stream<SettingState> _changeFoodPrice(String foodPrice) async* {
    var _a = await SharedPreferences.getInstance();
    await _a.setString(keys[2], foodPrice);
    yield OnChangeFoodPrice(foodPrice: foodPrice);
  }

  Stream<SettingState> _changePetPrice(String petPrice) async* {
    var _a = await SharedPreferences.getInstance();
    await _a.setString(keys[3], petPrice);
    yield OnChangePetPrice(petPrice: petPrice);
  }

  Stream<SettingState> _changeFoodWeight(String foodWeight) async* {
    var _a = await SharedPreferences.getInstance();
    await _a.setString(keys[4], foodWeight);
    yield OnChangeFoodWeight(foodWeight: foodWeight);
  }

  // * ---------------------------------------------------------------
  // * load event
  // * ---------------------------------------------------------------
  Stream<SettingState> _loadFoodUnit() async* {
    var _a = await SharedPreferences.getInstance();
    var _b = _a.getString(keys[0]);
    yield OnLoadFoodUnit(foodUnit: _b ?? '0');
  }

  Stream<SettingState> _loadWeightUnit() async* {
    var _a = await SharedPreferences.getInstance();
    var _b = _a.getString(keys[0]);
    yield OnLoadWeightUnit(weightUnit: _b ?? '0');
  }

  Stream<SettingState> _loadFoodPrice() async* {
    var _a = await SharedPreferences.getInstance();
    var _b = _a.getString(keys[0]);
    yield OnLoadFoodPrice(foodPrice: _b ?? '0');
  }

  Stream<SettingState> _loadPetPrice() async* {
    var _a = await SharedPreferences.getInstance();
    var _b = _a.getString(keys[0]);
    yield OnLoadPetPrice(petPrice: _b ?? '0');
  }

  Stream<SettingState> _loadFoodWeight() async* {
    var _a = await SharedPreferences.getInstance();
    var _b = _a.getString(keys[0]);
    yield OnLoadFoodWeight(foodWeight: _b ?? '0');
  }
}
