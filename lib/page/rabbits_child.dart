import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rabbits/bloc/rabbit_child/rabbit_child_bloc.dart';
import 'package:rabbits/bloc/rabbit_child/rabbit_child_event.dart';
import 'package:rabbits/bloc/rabbit_child/rabbit_child_state.dart';
import 'package:rabbits/data/static_data.dart';
import 'package:rabbits/model/rabbit_child_model.dart';
import 'package:rabbits/page/child_detail.dart';
import 'package:rabbits/util/util.dart';

// ignore: use_key_in_widget_constructors
class RabbitsChild extends StatefulWidget {
  static var tag = 'rabbits-child-page';

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<RabbitsChild> {
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
            title: const Text('Anakan kelinci'),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showDialogAddRabbitChild(),
            icon: const Icon(Icons.add),
            label: const Text('Tambah kandang'),
          ),
          body: _body,
        ));
  }

  final TextEditingController _textEditingControllerAddRabbitChildName =
      TextEditingController();
  _showDialogAddRabbitChild() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Tambah kandang'),
              content: TextField(
                controller: _textEditingControllerAddRabbitChildName,
                decoration:
                    const InputDecoration(hintText: 'Masukkan nama kandang'),
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
                      var _a = _textEditingControllerAddRabbitChildName.text;
                      if (_a.isNotEmpty) {
                        var _b = RabbitChildModel(
                          homeName: _a,
                          foodCount: '0',
                          petBorn: DateTime.now().toString(),
                          petWeight: '0',
                          key: DateTime.now().toString(),
                        );
                        context
                            .read<RabbitChildBloc>()
                            .add(Add(rabbitChildModel: _b));

                        //? dismiss dialog
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                          _textEditingControllerAddRabbitChildName.text = '';
                        }
                      }
                    },
                    child: const Text('Simpan')),
              ],
            ));
  }

  Util? _util;
  _init() {
    _util ??= Util()..init(context);

    //? get all rabbit child from database
    context.read<RabbitChildBloc>().add(GetAllRabbits());
  }

  List<RabbitChildModel> _listRabbitChildModel = [];
  List<String> _listRabbitChildKey = [];
  get _body => BlocBuilder<RabbitChildBloc, RabbitChildState>(
        builder: (context, state) {
          if (state is OnGetAllCompleted) {
            _listRabbitChildModel = state.listRabbitChild;
            _listRabbitChildKey = state.listRabbitChildKey;

            //? reset to initial state
            context.read<RabbitChildBloc>().add(ResetToInitial());
          } else if (state is OnIncrementFood) {
            var _index = _listRabbitChildKey.indexOf(state.rabbitKey);
            if (_index != -1) {
              var _a = _listRabbitChildModel[_index];
              _a.foodCount = state.foodCount;
              _listRabbitChildModel.removeAt(_index);
              _listRabbitChildModel.insert(_index, _a);
            }

            //? reset to initial state
            context.read<RabbitChildBloc>().add(ResetToInitial());
          } else if (state is OnDecrementFood) {
            var _index = _listRabbitChildKey.indexOf(state.rabbitKey);
            if (_index != -1) {
              var _a = _listRabbitChildModel[_index];
              _a.foodCount = state.foodCount;
              _listRabbitChildModel.removeAt(_index);
              _listRabbitChildModel.insert(_index, _a);
            }

            //? reset to initial state
            context.read<RabbitChildBloc>().add(ResetToInitial());
          } else if (state is OnChangePetBorn) {
            var _index = _listRabbitChildKey.indexOf(state.rabbitKey);
            if (_index != -1) {
              var _a = _listRabbitChildModel[_index];
              _a.petBorn = state.stringDateTime;
              _listRabbitChildModel.removeAt(_index);
              _listRabbitChildModel.insert(_index, _a);
            }

            //? reset to initial state
            context.read<RabbitChildBloc>().add(ResetToInitial());
          } else if (state is OnResetToZeroCompleted) {
            var _index = _listRabbitChildKey.indexOf(state.rabbitKey);
            if (_index != -1) {
              _listRabbitChildModel.removeAt(_index);
              _listRabbitChildModel.insert(_index, state.rabbitChildModel);
            }

            //? reset to initial state
            context.read<RabbitChildBloc>().add(ResetToInitial());
          } else if (state is OnDeletedRabbit) {
            var _index = _listRabbitChildKey.indexOf(state.rabbitKey);
            if (_index != -1) {
              _listRabbitChildModel.removeAt(_index);
              _listRabbitChildKey.removeAt(_index);
            }

            //? reset to initial state
            context.read<RabbitChildBloc>().add(ResetToInitial());
          } else if (state is OnAdd) {
            var _a = state.rabbitChildModel;
            _listRabbitChildKey.add(_a.key!);
            _listRabbitChildModel.add(_a);

            //? reset to initial state
            context.read<RabbitChildBloc>().add(ResetToInitial());
          }

          if (_listRabbitChildModel.isNotEmpty) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.only(bottom: 48 + 16 + 16),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) =>
                        _listItemChild(index, _listRabbitChildModel[index]),
                    itemCount: _listRabbitChildModel.length,
                  )
                ],
              ),
            );
          } else {
            return const Center(child: Text('Tidak ada data'));
          }
        },
      );

  String _getAge(DateTime petBorn) {
    var _a = DateTime.now();
    return '${_a.difference(petBorn).inDays}';
  }

  _listItemChild(index, RabbitChildModel rabbitChildModel) {
    var _iconColor = Colors.grey.shade500;

    var _petBorn = rabbitChildModel.petBorn ?? '';
    var _foodCount = int.parse(rabbitChildModel.foodCount ?? '0');
    var _petWeight = double.parse(rabbitChildModel.petWeight ?? '0');

    var _numberFormatPrice = NumberFormat('#,###');
    var _petPrice = _petWeight * StaticData.petPrice!;

    var _dateTimePetBorn =
        _petBorn.isNotEmpty ? DateTime.parse(_petBorn) : null;

    return Container(
      margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: Colors.blueGrey.shade50, width: 1.32),
      ),
      child: Material(
        clipBehavior: Clip.hardEdge,
        borderRadius: const BorderRadius.all(Radius.circular(8 - 1.32)),
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChildDetail(
                    childKey: rabbitChildModel.key,
                    name: rabbitChildModel.homeName,
                  ),
                ));
          },
          child: Container(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //? home name
                Text(
                  rabbitChildModel.homeName!,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: _util!.textTheme.headline6!.fontSize),
                ),
                Container(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.timelapse_rounded,
                      size: _util!.textTheme.subtitle1!.fontSize,
                      color: _iconColor,
                    ),
                    Container(width: 8),
                    Text(
                      'Lama pemeliharaan : '
                      '${_dateTimePetBorn != null ? _getAge(_dateTimePetBorn) : '-'} '
                      'hari',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                Container(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.pets_rounded,
                      size: _util!.textTheme.subtitle1!.fontSize,
                      color: _iconColor,
                    ),
                    Container(width: 8),
                    Text(
                      'Jumlah takaran pakan : $_foodCount '
                      'takar (${_numberFormatPrice.format(_foodCount * StaticData.foodWeight!).replaceAll(',', '.')} ${StaticData.unitFood == 0 ? 'kg' : 'gr'})',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                Container(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.monitor_weight_rounded,
                      size: _util!.textTheme.subtitle1!.fontSize,
                      color: _iconColor,
                    ),
                    Container(width: 8),
                    Text(
                      'Berat hewan : $_petWeight kg',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                Container(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.attach_money_rounded,
                      size: _util!.textTheme.subtitle1!.fontSize,
                      color: _iconColor,
                    ),
                    Container(width: 8),
                    Text(
                      'Perkiraan harga : Rp ${_numberFormatPrice.format(_petPrice).replaceAll(',', '.')},00',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),

                Container(height: 16),
                //? button add food
                ElevatedButton(
                    onPressed: () {
                      context
                          .read<RabbitChildBloc>()
                          .add(IncrementFood(rabbitKey: rabbitChildModel.key!));
                    },
                    child: const Text('Beri makan')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
