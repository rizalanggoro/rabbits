import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rabbits/bloc/rabbit_child/rabbit_child_bloc.dart';
import 'package:rabbits/bloc/rabbit_child/rabbit_child_event.dart';
import 'package:rabbits/bloc/rabbit_child/rabbit_child_state.dart';
import 'package:rabbits/data/calendar_data.dart';
import 'package:rabbits/data/static_data.dart';
import 'package:rabbits/model/rabbit_child_model.dart';
import 'package:rabbits/util/util.dart';

// ignore: use_key_in_widget_constructors
class ChildDetail extends StatefulWidget {
  static var tag = 'child-page';
  final String? childKey;
  final String? name;

  // ignore: use_key_in_widget_constructors
  const ChildDetail({this.childKey, this.name});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ChildDetail> {
  String _homeName = '';

  @override
  Widget build(BuildContext context) {
    _init();

    return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<RabbitChildBloc>()),
        ],
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: BlocBuilder<RabbitChildBloc, RabbitChildState>(
              builder: (context, state) {
                if (state is OnChangeHomeName) {
                  _homeName = state.homeName;
                  _textEditingControllerName.text = _homeName;

                  //? reset to initial state
                  context.read<RabbitChildBloc>().add(ResetToInitial());
                }
                return Text(_homeName);
              },
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    //? show dialog change home name
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Ganti nama'),
                        content: TextField(
                          controller: _textEditingControllerName,
                          decoration: const InputDecoration(hintText: 'Nama'),
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
                                var _homeName = _textEditingControllerName.text;
                                if (_homeName.isNotEmpty) {
                                  context
                                      .read<RabbitChildBloc>()
                                      .add(ChangeHomeName(
                                        rabbitKey: _rabbitChildModel!.key!,
                                        homeName: _homeName,
                                      ));
                                  //? dismiss dialog
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              child: const Text('Oke')),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_rounded)),
              Container(width: 8),
            ],
          ),
          body: _body,
        ));
  }

  Util? _util;
  final TextEditingController _textEditingControllerName =
      TextEditingController();
  _init() {
    _util ??= Util()..init(context);
    if (_homeName.isEmpty) {
      _homeName = widget.name!;
      _textEditingControllerName.text = _homeName;
    }

    //? get rabbit child by key
    context
        .read<RabbitChildBloc>()
        .add(GetRabbitByKey(rabbitKey: widget.childKey!));
  }

  String _getAge(DateTime petBorn) {
    var _a = DateTime.now();
    var _b = _a.difference(petBorn);
    return '${_b.inDays}';
  }

  final TextEditingController _textEditingControllerPetWeight =
      TextEditingController();
  RabbitChildModel? _rabbitChildModel;
  double _foodUsed = 0.0;
  double _foodUsedPrice = 0.0;
  double _foodCount = 0.0;
  double _petWeight = 0.0;
  double _petPrice = 0.0;
  double _profit = 0.0;
  DateTime _dateTimePetBorn = DateTime.now();
  get _body => BlocBuilder<RabbitChildBloc, RabbitChildState>(
        builder: (context, state) {
          if (state is OnGetByKeyCompleted) {
            _rabbitChildModel = state.rabbitChildModel;

            //? init pet detail
            if (_rabbitChildModel!.petBorn != null) {
              _dateTimePetBorn = DateTime.parse(_rabbitChildModel!.petBorn!);
              _foodCount = double.parse(_rabbitChildModel!.foodCount ?? '0');
              _petWeight = double.parse(_rabbitChildModel!.petWeight ?? '0');

              _textEditingControllerPetWeight.text = '$_petWeight';
              _textEditingControllerName.text = _rabbitChildModel!.homeName!;
            }

            //? reset to initial state
            context.read<RabbitChildBloc>().add(ResetToInitial());
          } else if (state is OnChangePetBorn) {
            //? on change pet born
            var _stringDateTime = state.stringDateTime;
            var _dateTime = DateTime.parse(_stringDateTime);
            _dateTimePetBorn = _dateTime;

            //? reset to initial state
            context.read<RabbitChildBloc>().add(ResetToInitial());
          } else if (state is OnIncrementFood) {
            //? on increment food count
            _foodCount = double.parse(state.foodCount);

            //? reset to initial state
            context.read<RabbitChildBloc>().add(ResetToInitial());
          } else if (state is OnDecrementFood) {
            //? on decrement food count
            _foodCount = double.parse(state.foodCount);

            //? reset to initial state
            context.read<RabbitChildBloc>().add(ResetToInitial());
          } else if (state is OnChangePetWeight) {
            //? on change pet weight
            _petWeight = double.parse(state.petWeight);

            //? reset to initial state
            context.read<RabbitChildBloc>().add(ResetToInitial());
          } else if (state is OnResetToZeroCompleted) {
            context
                .read<RabbitChildBloc>()
                .add(GetRabbitByKey(rabbitKey: state.rabbitKey));
          } else if (state is OnDeletedRabbit) {
            //? reset to initial state
            context.read<RabbitChildBloc>().add(ResetToInitial());

            WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
              //? pop back
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            });
          }

          //? initialize pet born
          var _petBornDay = _dateTimePetBorn.day;
          var _petBornMonth = CalendarData.month[_dateTimePetBorn.month - 1];
          var _petBornYear = _dateTimePetBorn.year;

          //? initialize pet food and pet food price
          _foodUsed = _foodCount * StaticData.foodWeight!;
          _foodUsedPrice = _foodUsed * StaticData.foodPrice!;

          //? initialize pet price
          _petPrice = StaticData.petPrice! * _petWeight;

          //? initialize profit
          _profit = _petPrice - _foodUsedPrice;

          //? view
          if (_rabbitChildModel != null) {
            var _numberFormat = NumberFormat('#.##');
            var _numberFormatPrice = NumberFormat('###,###');
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 8),
                  ListTile(
                    leading: const Icon(Icons.timelapse_rounded),
                    title: const Text('Lama pemeliharaan'),
                    subtitle: Text('${_getAge(_dateTimePetBorn)} hari'),
                  ),
                  ListTile(
                    leading: const Icon(null),
                    title: const Text('Tanggal lahir'),
                    subtitle: Text('$_petBornDay $_petBornMonth $_petBornYear'),
                    trailing: ElevatedButton(
                      child: const Text('Ubah'),
                      onPressed: () async {
                        var _selectedDateTime = await showDatePicker(
                          context: context,
                          initialDate: _dateTimePetBorn,
                          firstDate: DateTime(DateTime.now().year - 1),
                          lastDate: DateTime.now(),
                        );
                        context.read<RabbitChildBloc>().add(ChangePetBorn(
                            rabbitKey: _rabbitChildModel!.key!,
                            stringDateTime: _selectedDateTime!.toString()));
                        // _valueNotifierPetBorn.value = _selectedDateTime!;
                      },
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.pets_rounded),
                    title: const Text('Jumlah takaran pakan'),
                    subtitle: Text('${_foodCount.toInt()} takar'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              context.read<RabbitChildBloc>().add(IncrementFood(
                                  rabbitKey: _rabbitChildModel!.key!));
                            },
                            icon: const Icon(Icons.add_rounded)),
                        IconButton(
                            onPressed: () {
                              context.read<RabbitChildBloc>().add(DecrementFood(
                                  rabbitKey: _rabbitChildModel!.key!));
                            },
                            icon: const Icon(Icons.remove_rounded)),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(null),
                    title: const Text('Perkiraan pakan terpakai'),
                    subtitle: Text('${_numberFormat.format(_foodUsed)} '
                        '${StaticData.unitFood == 0 ? 'kilogram' : 'gram'}'),
                  ),
                  ListTile(
                    leading: const Icon(null),
                    title: const Text('Perkiraan harga pakan'),
                    subtitle: Text(
                        'Rp ${_numberFormatPrice.format(_foodUsedPrice).replaceAll(',', '.')},00'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.monitor_weight_rounded),
                    title: const Text('Berat hewan'),
                    subtitle: Text(
                        '$_petWeight ${StaticData.unitWeight == 0 ? 'kilogram' : 'gram'}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Berat hewan'),
                              content: TextField(
                                controller: _textEditingControllerPetWeight,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    hintText: 'Masukkan berat hewan'),
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
                                      var _petWeight =
                                          _textEditingControllerPetWeight.text;
                                      context.read<RabbitChildBloc>().add(
                                          ChangePetWeight(
                                              rabbitKey:
                                                  _rabbitChildModel!.key!,
                                              petWeight: _petWeight));

                                      //? close dialog
                                      if (Navigator.canPop(context)) {
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text('Oke')),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Ubah'),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.attach_money_rounded),
                    title: const Text('Perkiraan harga'),
                    subtitle: Text(
                        'Rp ${_numberFormatPrice.format(_petPrice).replaceAll(',', '.')},00'),
                  ),
                  ListTile(
                    leading: const Icon(null),
                    title: const Text('Perkiraan keuntungan'),
                    subtitle: Text(
                        'Rp ${_numberFormatPrice.format(_profit).replaceAll(',', '.')},00'),
                  ),
                  const Divider(),

                  //? button reset and delete
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 12),
                    child: Text(
                      'Pengaturan lainnya',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: _util!.textTheme.bodyText1!.fontSize,
                      ),
                    ),
                  ),
                  Container(height: 8),
                  ListTile(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Reset'),
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
                                  context.read<RabbitChildBloc>().add(
                                      ResetToZero(
                                          rabbitKey: _rabbitChildModel!.key!,
                                          homeName: _homeName));

                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text('Ya')),
                          ],
                          content: const Text(
                              'Apakah anda yakin ingin mereset data ke nol?'),
                        ),
                      );
                    },
                    leading: const Icon(Icons.restore_rounded),
                    title: const Text('Reset'),
                    subtitle:
                        Text('Mengembalikan semua data $_homeName ke nol'),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Hapus data'),
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
                                  context.read<RabbitChildBloc>().add(
                                      DeleteRabbit(
                                          rabbitKey: _rabbitChildModel!.key!));
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text('Ya')),
                          ],
                          content: Text(
                              'Apakah anda yakin akan menghapus $_homeName?'),
                        ),
                      );
                    },
                    leading: const Icon(Icons.delete_rounded),
                    title: const Text('Hapus data'),
                    subtitle: Text('Menghapus semua data $_homeName dari list'),
                  ),
                  Container(height: 8),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('Loading'),
            );
          }
        },
      );
}
