import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rabbits/bloc/a_setting/a_setting_bloc.dart';
import 'package:rabbits/bloc/food/food_bloc.dart';
import 'package:rabbits/data/a_static.dart';
import 'package:rabbits/data/unit.dart';
import 'package:rabbits/page/add_food.dart';
import 'package:rabbits/util/util.dart';
import 'package:rabbits/view/dialog_select_unit.dart';
import 'package:rabbits/view/dialog_text_field.dart';

// ignore: use_key_in_widget_constructors
class ADashboardSetting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ADashboardSetting> {
  @override
  Widget build(BuildContext context) {
    _init();

    return MultiBlocProvider(providers: [
      BlocProvider.value(value: context.read<FoodBloc>()),
      BlocProvider.value(value: context.read<ASettingBloc>()),
    ], child: _body());
  }

  _body() => SingleChildScrollView(
        child: Column(
          children: [
            _card(_settingParent()),
            _card(_settingChild(), top: 16),
            _card(_settingFood(), top: 16, bottom: 16),
          ],
        ),
      );

  _card(
    child, {
    double? top,
    double? bottom,
  }) {
    return Container(
      margin: EdgeInsets.only(top: top ?? 0.0, bottom: bottom ?? 0),
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 8,
          )
        ],
        color: Colors.white,
      ),
      child: Material(
        color: Colors.transparent,
        child: child,
      ),
    );
  }

  _settingParent() => BlocBuilder<ASettingBloc, ASettingState>(
        builder: (context, state) {
          if (state is ASettingOnChangeParentEstimateBorn) {
            AStatic.parentEstimateBorn = state.parentEstimateBorn;
            // reset to initial state
            context.read<ASettingBloc>().add(ASettingResetToInitial());
          } else if (state is ASettingOnChangeParentAddBox) {
            AStatic.parentAddBox = state.parentAddBox;
            // reset to initial state
            context.read<ASettingBloc>().add(ASettingResetToInitial());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
                child: Text(
                  'Indukan',
                  style: TextStyle(
                    fontSize: _util!.textTheme.bodyText1!.fontSize,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => DialogTextField(
                          title: 'Estimasi melahirkan',
                          hintText: 'Masukkan estimasi melahirkan',
                          textEditingController:
                              _textEditingControllerEstimateBorn,
                          onClickCancel: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          },
                          onClickSave: () {
                            var _a = _textEditingControllerEstimateBorn.text;
                            if (_a.isNotEmpty) {
                              context.read<ASettingBloc>().add(
                                  ASettingChangeParentEstimateBorn(
                                      parentEstimateBorn: _a));

                              // dismiss dialog
                              Navigator.pop(context);
                            }
                          },
                          textInputType: TextInputType.number));
                },
                title: const Text('Estimasi melahirkan'),
                subtitle: Text(
                  '${AStatic.parentEstimateBorn} hari setelah proses perkawinan',
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
              ),
              const Divider(),
              ListTile(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => DialogTextField(
                          title: 'Pemberian kotak',
                          hintText: 'Hari sebelum melahirkan',
                          textEditingController: _textEditingControllerAddBox,
                          onClickCancel: () => Navigator.pop(context),
                          onClickSave: () {
                            var _a = _textEditingControllerAddBox.text;
                            if (_a.isNotEmpty) {
                              context.read<ASettingBloc>().add(
                                  ASettingChangeParentAddBox(parentAddBox: _a));

                              // dismiss dialog
                              Navigator.pop(context);
                            }
                          },
                          textInputType: TextInputType.number));
                },
                title: const Text('Pemberian kotak melahirkan'),
                subtitle: Text(
                  '${AStatic.parentAddBox} hari sebelum proses melahirkan',
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          );
        },
      );

  _settingChild() => BlocBuilder<ASettingBloc, ASettingState>(
        builder: (context, state) {
          if (state is ASettingOnChangeChildSellUnit) {
            AStatic.childSellUnit = state.childSellUnit;
            context.read<ASettingBloc>().add(ASettingResetToInitial());
          } else if (state is ASettingOnChangeChildSellPrice) {
            AStatic.childSellPrice = state.childSellPrice;
            context.read<ASettingBloc>().add(ASettingResetToInitial());
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
                child: Text(
                  'Anakan',
                  style: TextStyle(
                    fontSize: _util!.textTheme.bodyText1!.fontSize,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (a) => DialogSelectUnit(
                      title: 'Satuan jual anakan',
                      onSelectedUnit: (unit) {
                        var _a = unit == Unit.kilogram ? '0' : '1';
                        context.read<ASettingBloc>().add(
                            ASettingChangeChildSellUnit(childSellUnit: _a));
                      },
                    ),
                  );
                },
                title: const Text('Satuan jual anakan'),
                subtitle: Text(
                  AStatic.childSellUnit == '0' ? 'Kilogram' : 'Gram',
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
              ),
              const Divider(),
              ListTile(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => DialogTextField(
                          title: 'Harga jual anakan',
                          hintText: 'Masukkan harga',
                          textEditingController:
                              _textEditingControllerChildSellPrice,
                          onClickCancel: () => Navigator.pop(context),
                          onClickSave: () {
                            var _a = _textEditingControllerChildSellPrice.text;
                            if (_a.isNotEmpty) {
                              context.read<ASettingBloc>().add(
                                  ASettingChangeChildSellPrice(
                                      childSellPrice: _a));

                              // dismiss dialog
                              Navigator.pop(context);
                            }
                          },
                          textInputType: TextInputType.number));
                },
                title: const Text('Harga jual anakan'),
                subtitle: Text(
                  'Rp ${NumberFormat('#,###').format(double.parse(AStatic.childSellPrice))} per '
                  '${AStatic.childSellUnit == '0' ? 'kilogram' : 'gram'}',
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          );
        },
      );

  _settingFood() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
          child: Text(
            'Pakan',
            style: TextStyle(
              fontSize: _util!.textTheme.bodyText1!.fontSize,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ListTile(
          onTap: () => Navigator.pushNamed(context, AddFood.tag),
          title: const Text('Tambah pakan'),
          leading: const Icon(Icons.add_rounded),
        ),

        // list food
        _listFood(),
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  Util? _util;
  final TextEditingController _textEditingControllerEstimateBorn =
      TextEditingController();
  final TextEditingController _textEditingControllerAddBox =
      TextEditingController();
  final TextEditingController _textEditingControllerChildSellPrice =
      TextEditingController();
  _init() {
    _util ??= Util()..init(context);
  }

  _listFood() => BlocBuilder<FoodBloc, FoodState>(
        builder: (context, state) {
          if (state is FoodOnAdd) {
            var _foodModel = state.foodModel;
            AStatic.listFoodKey.add(_foodModel.key!);
            AStatic.listFoodModel.add(_foodModel);

            // reset to initial state
            context.read<FoodBloc>().add(FoodResetToInitial());
          } else if (state is FoodOnUpdate) {
            var _foodModel = state.foodModel;
            var _index = AStatic.listFoodKey.indexOf(_foodModel.key!);
            if (_index != -1) {
              AStatic.listFoodModel.removeAt(_index);
              AStatic.listFoodModel.insert(_index, _foodModel);
            }

            // reset to initial state
            context.read<FoodBloc>().add(FoodResetToInitial());
          } else if (state is FoodOnDeleted) {
            var _foodKey = state.foodKey;
            var _index = AStatic.listFoodKey.indexOf(_foodKey);
            if (_index != -1) {
              AStatic.listFoodKey.removeAt(_index);
              AStatic.listFoodModel.removeAt(_index);
            }

            // reset to initial state
            context.read<FoodBloc>().add(FoodResetToInitial());
          }

          return Column(
            children: [
              if (AStatic.listFoodKey.isNotEmpty) const Divider(),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: AStatic.listFoodKey.length,
                itemBuilder: (a, index) => _listItemFood(index),
              )
            ],
          );
        },
      );

  _listItemFood(index) {
    var _isLast = index == AStatic.listFoodKey.length - 1;
    var _foodModel = AStatic.listFoodModel[index];
    var _foodUnit = _foodModel.foodUnit!;

    var _unit = _foodUnit == '0' ? 'kilogram' : 'gram';
    var _numFormatFoodWeight = NumberFormat('#,##0.##');
    var _numFormatFoodPrice = NumberFormat('#,###');

    var _foodWeight = _numFormatFoodWeight
        .format(double.parse(_foodModel.foodWeightPerDose!));
    var _foodPricePerUnit =
        _numFormatFoodPrice.format(double.parse(_foodModel.foodPricePerUnit!));
    var _foodPricePerDose =
        _numFormatFoodPrice.format(double.parse(_foodModel.foodPricePerDose!));

    return Column(
      children: [
        ListTile(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            title: Text(_foodModel.foodName!),
            subtitle: Text(
              '$_foodWeight $_unit / takar\n'
              'Rp $_foodPricePerUnit per $_unit\n'
              'Rp $_foodPricePerDose per takar',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddFood(
                                  foodModel: _foodModel,
                                )));
                  },
                  icon: const Icon(Icons.edit_rounded),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_rounded),
                  onPressed: () {
                    // show dialog confirm delete
                    showDialog(
                      context: context,
                      builder: (a) => AlertDialog(
                        title: const Text('Hapus pakan'),
                        content: Text(
                          'Hapus ${_foodModel.foodName} dari database?',
                        ),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Batal')),
                          TextButton(
                              onPressed: () {
                                // delete food from database by key
                                context.read<FoodBloc>().add(FoodDelete(
                                      foodKey: _foodModel.key!,
                                    ));

                                // dismiss dialog
                                Navigator.pop(context);
                              },
                              child: const Text('Hapus')),
                        ],
                      ),
                    );
                  },
                ),
              ],
            )),
        if (!_isLast) const Divider(),
      ],
    );
  }
}
