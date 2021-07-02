import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rabbits/bloc/setting/setting_bloc.dart';
import 'package:rabbits/bloc/setting/setting_event.dart';
import 'package:rabbits/bloc/setting/setting_state.dart';
import 'package:rabbits/data/unit.dart';
import 'package:rabbits/util/util.dart';
import 'package:rabbits/view/dialog_text_field.dart';

// ignore: use_key_in_widget_constructors
class Setting extends StatefulWidget {
  static var tag = 'setting-page';
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    _init();

    return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<SettingBloc>()),
        ],
        child: Scaffold(
          backgroundColor: Colors.white,
          body: _body,
          appBar: AppBar(
            title: const Text('Setelan'),
          ),
        ));
  }

  Util? _util;
  _init() {
    _util ??= Util()..init(context);

    _loadSettingFromDatabase();
  }

  _loadSettingFromDatabase() {
    context.read<SettingBloc>().add(GetAllSetting());
  }

  get _body =>
      BlocBuilder<SettingBloc, SettingState>(builder: (context, state) {
        if (state is OnGetAllSettingCompleted) {
          var _mapSetting = state.map;

          //? initialize map setting
          _valueNotifierFoodUnit.value = _mapSetting[SettingBloc.keys[0]] == '0'
              ? Unit.kilogram
              : Unit.gram;
          _valueNotifierWeightUnit.value =
              _mapSetting[SettingBloc.keys[1]] == '0'
                  ? Unit.kilogram
                  : Unit.gram;
          _textEditingControllerFoodPrice.text =
              '${int.parse(_mapSetting[SettingBloc.keys[2]])}';
          _textEditingControllerPetPrice.text =
              '${int.parse(_mapSetting[SettingBloc.keys[3]])}';
          _textEditingControllerFoodWeight.text =
              '${double.parse(_mapSetting[SettingBloc.keys[4]])}';

          SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
            //* estimate born
            _textEditingControllerEstimateBornDate.text =
                _mapSetting[SettingBloc.rabbitParentEstimateBornKey];
            _textEditingControllerEstimateBornDate.selection =
                TextSelection.fromPosition(TextPosition(
                    offset:
                        _textEditingControllerEstimateBornDate.text.length));

            //* add box
            _textEditingControllerAddBox.text =
                _mapSetting[SettingBloc.rabbitParentAddBoxKey];
            _textEditingControllerAddBox.selection = TextSelection.fromPosition(
                TextPosition(offset: _textEditingControllerAddBox.text.length));
          });
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 8),
              _tile1(state),
              const Divider(),
              _tile2(state),
              const Divider(),
              _tile3(state),
              const Divider(),
              _tile4(state),
              const Divider(),
              _tile5(state),
              const Divider(),

              //* rabbit parent
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                child: Text('Indukan',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: _util!.textTheme.bodyText1!.fontSize,
                      fontWeight: FontWeight.w600,
                    )),
              ),
              _tile6(state),
              const Divider(),
              _tile7(state),

              //* spacer
              Container(height: 8),
            ],
          ),
        );
      });

  //* tile estimate born date
  final TextEditingController _textEditingControllerEstimateBornDate =
      TextEditingController();
  _tile6(SettingState state) {
    return ListTile(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => DialogTextField(
                  title: 'Estimasi melahirkan',
                  hintText: 'Masukkan estimasi melahirkan',
                  textEditingController: _textEditingControllerEstimateBornDate,
                  onClickCancel: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  onClickSave: () {
                    var _a = _textEditingControllerEstimateBornDate.text;
                    if (_a.isNotEmpty) {
                      //* save data to database
                      context.read<SettingBloc>().add(
                          ChangeRabbitParentEstimateBorn(
                              rabbitParentEstimateBorn: _a));

                      //* dismiss dialog
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  textInputType: TextInputType.number,
                ));
      },
      title: const Text('Estimasi indukan melahirkan'),
      subtitle: Text(
          '${_textEditingControllerEstimateBornDate.text} hari setelah proses perkawinan'),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }

  //* tile add box for rabbit parent
  final TextEditingController _textEditingControllerAddBox =
      TextEditingController();
  _tile7(SettingState state) {
    if (state is OnChangeRabbitParentAddBox) {
      var _a = state.rabbitParentAddBox;
      _textEditingControllerAddBox.text = _a;
    }

    return ListTile(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => DialogTextField(
                  title: 'Penambahan kotak',
                  hintText: 'Hari sebelum melahirkan',
                  textEditingController: _textEditingControllerAddBox,
                  onClickCancel: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  onClickSave: () {
                    var _a = _textEditingControllerAddBox.text;
                    if (_a.isNotEmpty) {
                      //* insert data to database
                      context.read<SettingBloc>().add(
                          ChangeRabbitParentAddBox(rabbitParentAddBox: _a));

                      //* reset to initial state
                      context.read<SettingBloc>().add(ResetToInitial());

                      //* dismiss dialog
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  textInputType: TextInputType.number,
                ));
      },
      title: const Text('Pemberian kotak melahirkan'),
      subtitle: Text(
          '${_textEditingControllerAddBox.text} hari sebelum proses melahirkan'),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }

  //? tile food unit
  final ValueNotifier<Unit> _valueNotifierFoodUnit =
      ValueNotifier(Unit.kilogram);
  _tile1(SettingState state) {
    if (state is OnLoadFoodUnit) {
      _valueNotifierFoodUnit.value =
          state.foodUnit == '0' ? Unit.kilogram : Unit.gram;

      //? reset to initial state
      context.read<SettingBloc>().add(ResetToInitial());
    } else if (state is OnChangeFoodUnit) {
      _valueNotifierFoodUnit.value =
          state.foodUnit == '0' ? Unit.kilogram : Unit.gram;

      //? reset to initial state
      context.read<SettingBloc>().add(ResetToInitial());
    }
    return ListTile(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Satuan pakan kelinci'),
                  contentPadding:
                      const EdgeInsets.only(left: 0, right: 0, top: 8),
                  content: ValueListenableBuilder(
                    valueListenable: _valueNotifierFoodUnit,
                    builder: (context, value, child) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile<Unit>(
                          title: const Text('Kilogram'),
                          value: Unit.kilogram,
                          groupValue: _valueNotifierFoodUnit.value,
                          onChanged: (value) {
                            _valueNotifierFoodUnit.value = Unit.kilogram;
                          },
                        ),
                        RadioListTile<Unit>(
                          title: const Text('Gram'),
                          value: Unit.gram,
                          groupValue: _valueNotifierFoodUnit.value,
                          onChanged: (value) {
                            _valueNotifierFoodUnit.value = Unit.gram;
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Batal')),
                    TextButton(
                        onPressed: () {
                          var _a = _valueNotifierFoodUnit.value;
                          var _b = _a == Unit.kilogram ? '0' : '1';
                          context
                              .read<SettingBloc>()
                              .add(ChangeFoodUnit(foodUnit: _b));

                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Oke')),
                  ],
                ));
      },
      title: const Text('Satuan pakan kelinci'),
      subtitle: Text(_valueNotifierFoodUnit.value == Unit.kilogram
          ? 'Kilogram (kg)'
          : 'Gram (g)'),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }

  //? tile weight unit
  final ValueNotifier<Unit> _valueNotifierWeightUnit =
      ValueNotifier(Unit.kilogram);
  _tile2(SettingState state) {
    if (state is OnLoadWeightUnit) {
      var _a = state.weightUnit;
      _valueNotifierWeightUnit.value = _a == '0' ? Unit.kilogram : Unit.gram;

      //? reset to initial state
      context.read<SettingBloc>().add(ResetToInitial());
    } else if (state is OnChangeWeightUnit) {
      var _a = state.weightUnit;
      _valueNotifierWeightUnit.value = _a == '0' ? Unit.kilogram : Unit.gram;

      //? reset to initial state
      context.read<SettingBloc>().add(ResetToInitial());
    }
    return ListTile(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Satuan berat kelinci'),
                  contentPadding:
                      const EdgeInsets.only(left: 0, right: 0, top: 8),
                  content: ValueListenableBuilder(
                    valueListenable: _valueNotifierWeightUnit,
                    builder: (context, value, child) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile<Unit>(
                          title: const Text('Kilogram'),
                          value: Unit.kilogram,
                          groupValue: _valueNotifierWeightUnit.value,
                          onChanged: (value) {
                            _valueNotifierWeightUnit.value = Unit.kilogram;
                          },
                        ),
                        RadioListTile<Unit>(
                          title: const Text('Gram'),
                          value: Unit.gram,
                          groupValue: _valueNotifierWeightUnit.value,
                          onChanged: (value) {
                            _valueNotifierWeightUnit.value = Unit.gram;
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Batal')),
                    TextButton(
                        onPressed: () {
                          var _a = _valueNotifierWeightUnit.value;
                          var _b = _a == Unit.kilogram ? '0' : '1';
                          context
                              .read<SettingBloc>()
                              .add(ChangeWeightUnit(weightUnit: _b));

                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Oke')),
                  ],
                ));
      },
      title: const Text('Satuan berat kelinci'),
      subtitle: Text(_valueNotifierWeightUnit.value == Unit.kilogram
          ? 'Kilogram (kg)'
          : 'Gram (g)'),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }

  //? tile food price
  final TextEditingController _textEditingControllerFoodPrice =
      TextEditingController();
  _tile3(SettingState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Harga pakan kelinci',
            style: TextStyle(
              color: Colors.black,
              fontSize: _util!.textTheme.subtitle1!.fontSize,
            ),
          ),
          Text(
            'Masukkan harga pakan kelinci untuk setiap '
            '${_valueNotifierFoodUnit.value == Unit.kilogram ? 'kilogram' : 'gram'}',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: _util!.textTheme.bodyText1!.fontSize,
            ),
          ),
          Container(height: 8),
          TextField(
            onSubmitted: (value) {
              var _a = value;
              if (_a.isNotEmpty) {
                context.read<SettingBloc>().add(ChangeFoodPrice(foodPrice: _a));
              }
            },
            controller: _textEditingControllerFoodPrice,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Harga per '
                  '${_valueNotifierFoodUnit.value == Unit.kilogram ? 'kilogram' : 'gram'}',
            ),
          ),
        ],
      ),
    );
  }

  //? tile pet price
  final TextEditingController _textEditingControllerPetPrice =
      TextEditingController();
  _tile4(SettingState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Harga kelinci',
            style: TextStyle(
              color: Colors.black,
              fontSize: _util!.textTheme.subtitle1!.fontSize,
            ),
          ),
          Text(
            'Masukkan harga kelinci untuk setiap ${_valueNotifierWeightUnit.value == Unit.kilogram ? 'kilogram' : 'gram'}',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: _util!.textTheme.bodyText1!.fontSize,
            ),
          ),
          Container(height: 8),
          TextField(
            onSubmitted: (value) {
              var _a = value;
              if (_a.isNotEmpty) {
                context.read<SettingBloc>().add(ChangePetPrice(petPrice: _a));
              }
            },
            controller: _textEditingControllerPetPrice,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText:
                  'Harga per ${_valueNotifierWeightUnit.value == Unit.kilogram ? 'kilogram' : 'gram'}',
            ),
          ),
        ],
      ),
    );
  }

  //? tile food weight
  final TextEditingController _textEditingControllerFoodWeight =
      TextEditingController();
  _tile5(SettingState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Berat pakan',
            style: TextStyle(
              fontSize: _util!.textTheme.subtitle1!.fontSize,
            ),
          ),
          Container(height: 4),
          Text(
            'Berat pakan untuk 1 takar dalam satuan ${_valueNotifierFoodUnit.value == Unit.kilogram ? 'kilogram' : 'gram'}',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
          Container(height: 8),
          TextField(
            onSubmitted: (value) {
              var _a = value;
              if (_a.isNotEmpty) {
                context
                    .read<SettingBloc>()
                    .add(ChangeFoodWeight(foodWeight: _a));
              }
            },
            controller: _textEditingControllerFoodWeight,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Berat per takar'),
          ),
        ],
      ),
    );
  }
}
