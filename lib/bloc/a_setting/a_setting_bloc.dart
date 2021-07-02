import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'a_setting_event.dart';
part 'a_setting_state.dart';

class ASettingBloc extends Bloc<ASettingEvent, ASettingState> {
  ASettingBloc() : super(ASettingInitial());

  static const parentEstimateBornKey = 'a';
  static const parentAddBoxKey = 'b';
  static const childSellUnitKey = 'c';
  static const childSellPriceKey = 'd';

  @override
  Stream<ASettingState> mapEventToState(ASettingEvent event) async* {
    if (event is ASettingResetToInitial) {
      yield ASettingInitial();
    } else if (event is ASettingChangeParentEstimateBorn) {
      // change parent estimate born
      await _change(parentEstimateBornKey, event.parentEstimateBorn);
      yield ASettingOnChangeParentEstimateBorn(
          parentEstimateBorn: event.parentEstimateBorn);
    } else if (event is ASettingChangeParentAddBox) {
      // change parent add box
      await _change(parentAddBoxKey, event.parentAddBox);
      yield ASettingOnChangeParentAddBox(parentAddBox: event.parentAddBox);
    } else if (event is ASettingChangeChildSellUnit) {
      // change child sell unit
      await _change(childSellUnitKey, event.childSellUnit);
      yield ASettingOnChangeChildSellUnit(childSellUnit: event.childSellUnit);
    } else if (event is ASettingChangeChildSellPrice) {
      // change child sell price
      await _change(childSellPriceKey, event.childSellPrice);
      yield ASettingOnChangeChildSellPrice(
          childSellPrice: event.childSellPrice);
    } else if (event is ASettingGetAll) {
      // get all setting from database
      var _mapSetting = {
        parentEstimateBornKey: await _getString(parentEstimateBornKey),
        parentAddBoxKey: await _getString(parentAddBoxKey),
        childSellUnitKey: await _getString(childSellUnitKey),
        childSellPriceKey: await _getString(childSellPriceKey),
      };
      yield ASettingOnGetAll(mapSetting: _mapSetting);
    }
  }

  Future<bool> _change(String key, String data) async {
    var _a = await SharedPreferences.getInstance();
    return _a.setString('a-setting-$key', data);
  }

  Future<String> _getString(String key, {String? def}) async {
    var _a = await SharedPreferences.getInstance();
    return _a.getString('a-setting-$key') ?? def ?? '';
  }

  Future<Map<String, dynamic>> getAll() async {
    // get all setting from database
    var _mapSetting = {
      parentEstimateBornKey: await _getString(parentEstimateBornKey, def: '0'),
      parentAddBoxKey: await _getString(parentAddBoxKey, def: '0'),
      childSellUnitKey: await _getString(childSellUnitKey, def: '0'),
      childSellPriceKey: await _getString(childSellPriceKey, def: '0'),
    };
    return _mapSetting;
  }
}
