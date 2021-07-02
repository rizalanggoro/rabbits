part of 'a_setting_bloc.dart';

@immutable
abstract class ASettingEvent {}

class ASettingResetToInitial extends ASettingEvent {}

class ASettingGetAll extends ASettingEvent {}

class ASettingChangeParentEstimateBorn extends ASettingEvent {
  final String parentEstimateBorn;
  ASettingChangeParentEstimateBorn({required this.parentEstimateBorn});
}

class ASettingChangeParentAddBox extends ASettingEvent {
  final String parentAddBox;
  ASettingChangeParentAddBox({required this.parentAddBox});
}

class ASettingChangeChildSellUnit extends ASettingEvent {
  final String childSellUnit;
  ASettingChangeChildSellUnit({required this.childSellUnit});
}

class ASettingChangeChildSellPrice extends ASettingEvent {
  final String childSellPrice;
  ASettingChangeChildSellPrice({required this.childSellPrice});
}
