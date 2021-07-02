import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rabbits/bloc/food/food_bloc.dart';
import 'package:rabbits/data/unit.dart';
import 'package:rabbits/model/food_model.dart';
import 'package:rabbits/util/util.dart';
import 'package:rabbits/view/a_card.dart';
import 'package:rabbits/view/app_bar_back_button.dart';
import 'package:rabbits/view/dialog_select_unit.dart';
import 'package:rabbits/view/dialog_text_field.dart';

// ignore: use_key_in_widget_constructors
class AddFood extends StatefulWidget {
  static var tag = 'add-food-page';

  final FoodModel? foodModel;
  // ignore: use_key_in_widget_constructors
  const AddFood({this.foodModel});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AddFood> {
  @override
  Widget build(BuildContext context) {
    _init();

    return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<FoodBloc>()),
        ],
        child: Scaffold(
          appBar: AppBar(
            leading: AppBarBackButton(),
            title: Text(
              '${_isEditMode ? 'Edit' : 'Tambah'} pakan',
            ),
          ),
          body: _body,
          floatingActionButton: FloatingActionButton(
            onPressed: () => _done(),
            child: const Icon(Icons.done_rounded),
          ),
        ));
  }

  get _body => BlocBuilder<FoodBloc, FoodState>(
        builder: (context, state) {
          if (state is FoodOnAdd) {
            SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
              // reset to initial state
              context.read<FoodBloc>().add(FoodResetToInitial());

              // pop page
              Navigator.pop(context);
            });
          } else if (state is FoodOnUpdate) {
            SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
              // reset to initial state
              context.read<FoodBloc>().add(FoodResetToInitial());

              // pop page
              Navigator.pop(context);
            });
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // text field food name
                ACard(
                  child: TextField(
                    controller: _textEditingControllerFoodName,
                    decoration: const InputDecoration(
                      hintText: 'Nama pakan',
                      border: InputBorder.none,
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),

                ACard(
                  child: Column(
                    children: [
                      Padding(
                        child: Text(
                          'Takaran pakan',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: _util!.textTheme.bodyText1!.fontSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        padding:
                            const EdgeInsets.only(top: 16, left: 16, bottom: 8),
                      ),

                      // list tile food unit
                      ListTile(
                        onTap: () {
                          FocusScope.of(context).unfocus();

                          showDialog(
                            context: context,
                            builder: (builder) => DialogSelectUnit(
                              title: 'Satuan takaran pakan',
                              onSelectedUnit: (unit) {
                                _mapFood['a'] = unit;

                                // notify food dose changes
                                _valueNotifierFoodDose.value++;
                              },
                            ),
                          );
                        },
                        title: const Text('Satuan takaran pakan'),
                        subtitle: ValueListenableBuilder(
                          builder: (a, b, c) {
                            var _unit = _mapFood['a'];

                            return Text(
                              _unit == Unit.kilogram ? 'Kilogram' : 'Gram',
                            );
                          },
                          valueListenable: _valueNotifierFoodDose,
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                      ),
                      const Divider(),

                      // list tile food weight
                      ListTile(
                        onTap: () {
                          FocusScope.of(context).unfocus();

                          showDialog(
                            context: context,
                            builder: (a) => DialogTextField(
                              title: 'Berat pakan',
                              hintText: 'Masukkan berat pakan',
                              textEditingController:
                                  _textEditingControllerFoodWeightPerDose,
                              onClickCancel: () => Navigator.pop(context),
                              onClickSave: () {
                                var _a = _textEditingControllerFoodWeightPerDose
                                    .text;
                                if (_a.isNotEmpty) {
                                  _mapFood['b'] = _a;

                                  // notify food dose changes
                                  _valueNotifierFoodDose.value++;

                                  // dismiss dialog
                                  Navigator.pop(context);
                                }
                              },
                              textInputType: TextInputType.number,
                            ),
                          );
                        },
                        title: const Text('Berat takaran pakan'),
                        subtitle: ValueListenableBuilder(
                          builder: (a, b, c) {
                            var _unit = _mapFood['a'];
                            var _weight = _mapFood['b'];
                            var _numFormat = NumberFormat('#,##0.##');
                            _weight = _numFormat.format(double.parse(_weight));

                            return Text(
                              '$_weight ${_unit == Unit.kilogram ? 'kilogram' : 'gram'} per takar',
                            );
                          },
                          valueListenable: _valueNotifierFoodDose,
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.only(bottom: 8),
                ),

                ACard(
                  child: Column(
                    children: [
                      Padding(
                        child: Text(
                          'Harga pakan',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: _util!.textTheme.bodyText1!.fontSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        padding:
                            const EdgeInsets.only(top: 16, left: 16, bottom: 8),
                      ),

                      // list tile price per unit
                      ListTile(
                        onTap: () {
                          FocusScope.of(context).unfocus();

                          showDialog(
                            context: context,
                            builder: (a) => DialogTextField(
                              title: 'Harga pakan',
                              hintText: 'Masukkan harga pakan',
                              textEditingController:
                                  _textEditingControllerFoodPricePerUnit,
                              onClickCancel: () => Navigator.pop(context),
                              onClickSave: () {
                                var _a =
                                    _textEditingControllerFoodPricePerUnit.text;
                                if (_a.isNotEmpty) {
                                  _mapFood['c'] = _a;

                                  // notify food price changes
                                  _valueNotifierFoodDose.value++;

                                  // dismiss dialog
                                  Navigator.pop(context);
                                }
                              },
                              textInputType: TextInputType.number,
                            ),
                          );
                        },
                        title: const Text('Harga pakan'),
                        subtitle: ValueListenableBuilder(
                          valueListenable: _valueNotifierFoodDose,
                          builder: (a, b, c) {
                            var _unit = _mapFood['a'];
                            var _price = _mapFood['c'];
                            var _numFormat = NumberFormat('#,###');
                            _price = _numFormat.format(double.parse(_price));

                            return Text(
                              'Rp $_price per ${_unit == Unit.kilogram ? 'kilogram' : 'gram'}',
                            );
                          },
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  margin: const EdgeInsets.only(top: 16, bottom: 16),
                  padding: const EdgeInsets.only(bottom: 8),
                ),
              ],
            ),
          );
        },
      );

  Util? _util;
  final TextEditingController _textEditingControllerFoodName =
      TextEditingController();

  // food dose
  final ValueNotifier<int> _valueNotifierFoodDose = ValueNotifier(0);
  final Map<String, dynamic> _mapFood = {
    'a': Unit.kilogram,
    'b': '0',
    'c': '0',
  };
  final TextEditingController _textEditingControllerFoodWeightPerDose =
      TextEditingController();
  final TextEditingController _textEditingControllerFoodPricePerUnit =
      TextEditingController();

  bool _isEditMode = false;
  bool _isEditModeInit = false;
  FoodModel? _foodModel;
  _init() {
    _util ??= Util()..init(context);

    _isEditMode = widget.foodModel != null;
    if (_isEditMode && !_isEditModeInit) {
      _foodModel = widget.foodModel!;
      _textEditingControllerFoodName.text = _foodModel!.foodName!;
      _mapFood['a'] = _foodModel!.foodUnit;
      _mapFood['b'] = _foodModel!.foodWeightPerDose;
      _mapFood['c'] = _foodModel!.foodPricePerUnit;

      _isEditModeInit = true;
      _valueNotifierFoodDose.value++;
    }
  }

  _done() {
    var _key = DateTime.now().toString();
    if (_isEditMode) {
      _key = _foodModel!.key!;
    }
    var _foodName = _textEditingControllerFoodName.text;
    if (_foodName.isNotEmpty) {
      var _foodUnit = _mapFood['a'] == Unit.kilogram ? '0' : '1';
      var _foodWeightPerDose = _mapFood['b'];
      var _foodPricePerUnit = _mapFood['c'];
      var _foodPricePerDose =
          (double.parse(_foodWeightPerDose) * double.parse(_foodPricePerUnit))
              .toString();

      var _foodModel = FoodModel(
        key: _key,
        foodName: _foodName,
        foodUnit: _foodUnit,
        foodWeightPerDose: _foodWeightPerDose,
        foodPricePerUnit: _foodPricePerUnit,
        foodPricePerDose: _foodPricePerDose,
      );

      // put food model to database
      if (_isEditMode) {
        context.read<FoodBloc>().add(FoodUpdate(foodModel: _foodModel));
      } else {
        context.read<FoodBloc>().add(FoodAdd(foodModel: _foodModel));
      }
    }
  }
}
