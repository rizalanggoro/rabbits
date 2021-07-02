part of 'a_setting_bloc.dart';

@immutable
abstract class ASettingState {}

class ASettingInitial extends ASettingState {}

class ASettingOnGetAll extends ASettingState {
  final Map<String, dynamic> mapSetting;
  ASettingOnGetAll({required this.mapSetting});
}

class ASettingOnChangeParentEstimateBorn extends ASettingState {
  final String parentEstimateBorn;
  ASettingOnChangeParentEstimateBorn({required this.parentEstimateBorn});
}

class ASettingOnChangeParentAddBox extends ASettingState {
  final String parentAddBox;
  ASettingOnChangeParentAddBox({required this.parentAddBox});
}

class ASettingOnChangeChildSellUnit extends ASettingState {
  final String childSellUnit;
  ASettingOnChangeChildSellUnit({required this.childSellUnit});
}

class ASettingOnChangeChildSellPrice extends ASettingState {
  final String childSellPrice;
  ASettingOnChangeChildSellPrice({required this.childSellPrice});
}
