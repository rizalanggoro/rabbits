import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rabbits/bloc/a_child/a_child_bloc.dart';
import 'package:rabbits/data/a_static.dart';
import 'package:rabbits/model/a_child_model.dart';
import 'package:rabbits/util/util.dart';
import 'package:rabbits/view/a_card.dart';
import 'package:rabbits/view/app_bar_back_button.dart';
import 'package:rabbits/view/dialog/a_dialog_text_field.dart';

// ignore: use_key_in_widget_constructors
class AChildDetail extends StatefulWidget {
  static var tag = 'a-child-detail-page';

  final int? index;
  // ignore: use_key_in_widget_constructors
  const AChildDetail({this.index});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AChildDetail> {
  @override
  Widget build(BuildContext context) {
    _init();

    return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<AChildBloc>()),
        ],
        child: BlocBuilder<AChildBloc, AChildState>(
          builder: (context, state) {
            if (state is AChildOnChangeBornDate) {
              var _bornDate = state.bornDate;
              _childModel!.childBornDate = _bornDate;
              context.read<AChildBloc>().add(AChildResetInitial());
            } else if (state is AChildOnChangeIndex) {
              _childModel = AStatic.listChildModel[_index];
              context.read<AChildBloc>().add(AChildResetInitial());
            } else if (state is AChildOnChangeWeight) {
              _childModel!.childWeight = state.childWeight;
              context.read<AChildBloc>().add(AChildResetInitial());
            } else if (state is AChildOnChangeFoodMap) {
              _childModel!.childFoodMap = state.childFoodMap;
              context.read<AChildBloc>().add(AChildResetInitial());
            } else if (state is AChildOnResetData) {
              _childModel!.childWeight = '0';
              _childModel!.childBornDate = DateTime.now().toString();
              _childModel!.childFoodMap = '{}';
              _childModel!.childWeight = '0';
              context.read<AChildBloc>().add(AChildResetInitial());
            } else if (state is AChildOnDeleteData) {
              var _childKey = state.childKey;
              var _index = AStatic.listChildKey.indexOf(_childKey);
              if (_index != -1) {
                AStatic.listChildKey.removeAt(_index);
                AStatic.listChildModel.removeAt(_index);

                SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
                  context.read<AChildBloc>().add(AChildResetInitial());
                  Navigator.pop(context);
                });
              }
            } else if (state is AChildOnChangeName) {
              _childModel!.childName = state.childName;
              context.read<AChildBloc>().add(AChildResetInitial());
            }

            return Scaffold(
              appBar: AppBar(
                title: Text(_childModel!.childName!),
                leading: AppBarBackButton(),
                actions: [
                  IconButton(
                      onPressed: () => _showDialogChangeName(),
                      icon: const Icon(Icons.edit_rounded)),
                  Container(width: 8),
                ],
              ),
              body: _body,
            );
          },
        ));
  }

  Util? _util;
  AChildModel? _childModel;
  int _index = -1;
  final NumberFormat _numberFormat = NumberFormat('#,##0.##');
  final NumberFormat _numberFormatPrice = NumberFormat('#,###');
  _init() {
    _util ??= Util()..init(context);
    if (_index == -1) _index = widget.index!;
    _childModel = AStatic.listChildModel[_index];
  }

  get _body => Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _card1(),
                _card2(),
                _card3(),
                _card4(),
                Container(height: 56),
              ],
            ),
          ),

          // button prev and next
          Align(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.08),
                    blurRadius: 8,
                  ),
                ],
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.center,
              height: 56,
              child: Material(
                color: Colors.transparent,
                child: Row(
                  children: [
                    OutlinedButton(
                      child: const Text('Sebelumnya'),
                      onPressed: _index > 0
                          ? () {
                              _index--;
                              context
                                  .read<AChildBloc>()
                                  .add(AChildChangeIndex());
                            }
                          : null,
                    ),
                    Container(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                        ),
                        child: const Text('Selanjutnya'),
                        onPressed: _index < AStatic.listChildKey.length - 1
                            ? () {
                                _index++;
                                context
                                    .read<AChildBloc>()
                                    .add(AChildChangeIndex());
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            alignment: Alignment.bottomCenter,
          ),
        ],
      );

  _card1() => ACard(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          // list tile passed day
          ListTile(
            leading: const Icon(Icons.timelapse_rounded),
            title: const Text('Lama pemeliharaan'),
            subtitle: Text('${_parsePassedDay()} hari'),
          ),
          const Divider(indent: 56 + 16),

          // list tile born date
          ListTile(
            leading: const Icon(null),
            title: const Text('Tanggal lahir'),
            subtitle: Text(
              _util!.parseDate(_childModel!.childBornDate!),
            ),
            trailing: ElevatedButton(
              child: const Text('Ubah'),
              onPressed: () => _showDialogChangeBornDate(),
            ),
          ),
          const Divider(),

          // list tile child weight
          ListTile(
            leading: const Icon(Icons.monitor_weight_rounded),
            title: const Text('Berat anakan'),
            subtitle: Text(
              '${_numberFormat.format(double.parse(_childModel!.childWeight!))} kilogram',
            ),
            trailing: ElevatedButton(
              child: const Text('Ubah'),
              onPressed: () => _showDialogChangeWeight(),
            ),
          ),
        ],
      ));

  double _totalFoodPrice = 0;
  _card2() {
    Map<String, dynamic> _childFoodMap = jsonDecode(_childModel!.childFoodMap!);
    double _totalPrice = 0;

    return ACard(
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 16, bottom: 8),
            child: Text(
              'Pakan',
              style: TextStyle(
                fontSize: _util!.textTheme.bodyText1!.fontSize,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),

          // list view food
          ListView.builder(
            itemBuilder: (context, index) {
              var _model = AStatic.listFoodModel[index];
              var _dose = _childFoodMap[_model.key] ?? '0';
              var _weight =
                  double.parse(_model.foodWeightPerDose!) * double.parse(_dose);
              var _price =
                  double.parse(_dose) * double.parse(_model.foodPricePerDose!);
              _totalPrice += _price;

              _totalFoodPrice = _totalPrice;

              return Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    title: Text(_model.foodName!),
                    subtitle: Padding(
                      child: Text(
                        'Takaran : $_dose takar\n'
                        'Terpakai : ${_numberFormat.format(_weight)} ${_model.foodUnit == '0' ? 'kilogram' : 'gram'}\n'
                        'Harga : Rp ${_numberFormatPrice.format(_price)}',
                      ),
                      padding: const EdgeInsets.only(top: 4),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: _childFoodMap[_model.key!] == null
                                ? null
                                : () {
                                    var _count =
                                        int.parse(_childFoodMap[_model.key!]);
                                    if (_count > 0) {
                                      _count--;
                                      _childFoodMap[_model.key!] =
                                          _count.toString();
                                      var _jsonFoodMap =
                                          jsonEncode(_childFoodMap);

                                      context
                                          .read<AChildBloc>()
                                          .add(AChildChangeFoodMap(
                                            childKey: _childModel!.childKey!,
                                            childFoodMap: _jsonFoodMap,
                                          ));
                                    }
                                  },
                            icon: const Icon(Icons.remove_rounded)),
                        IconButton(
                            onPressed: () {
                              if (_childFoodMap[_model.key!] == null) {
                                _childFoodMap[_model.key!] = '0';
                              }
                              var _count =
                                  int.parse(_childFoodMap[_model.key!]);
                              _count++;
                              _childFoodMap[_model.key!] = _count.toString();
                              var _jsonFoodMap = jsonEncode(_childFoodMap);

                              context
                                  .read<AChildBloc>()
                                  .add(AChildChangeFoodMap(
                                    childKey: _childModel!.childKey!,
                                    childFoodMap: _jsonFoodMap,
                                  ));
                            },
                            icon: const Icon(Icons.add_rounded)),
                      ],
                    ),
                  ),
                  if (index != AStatic.listFoodKey.length - 1) const Divider(),
                ],
              );
            },
            itemCount: AStatic.listFoodKey.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ],
      ),
    );
  }

  _card3() {
    var _childSellPrice = double.parse(AStatic.childSellPrice);
    var _childWeight = double.parse(_childModel!.childWeight!);
    var _estimatePrice = _childWeight * _childSellPrice;
    var _estimateBenefit = _estimatePrice - _totalFoodPrice;

    return ACard(
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 16, bottom: 8),
            child: Text(
              'Harga',
              style: TextStyle(
                fontSize: _util!.textTheme.bodyText1!.fontSize,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),

          // list tile estimate price
          ListTile(
            title: const Text('Perkiraan harga'),
            subtitle: Text(
              'Rp ${_numberFormatPrice.format(_estimatePrice)}',
            ),
            leading: const Icon(Icons.attach_money_rounded),
          ),
          const Divider(indent: 56 + 16),

          // list tile estimate price
          ListTile(
            title: const Text('Perkiraan harga pakan'),
            subtitle: Text('Rp ${_numberFormatPrice.format(_totalFoodPrice)}'),
            leading: const Icon(null),
          ),
          const Divider(indent: 56 + 16),

          // list tile estimate price
          ListTile(
            title: const Text('Perkiraan keuntungan'),
            subtitle: Text('Rp ${_numberFormatPrice.format(_estimateBenefit)}'),
            leading: const Icon(null),
          ),
        ],
      ),
    );
  }

  _card4() => ACard(
        padding: const EdgeInsets.symmetric(vertical: 8),
        margin: const EdgeInsets.only(top: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 16, bottom: 8),
              child: Text(
                'Pengaturan lainnya',
                style: TextStyle(
                  fontSize: _util!.textTheme.bodyText1!.fontSize,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),

            // list tile estimate price
            ListTile(
              onTap: () => _showDialogResetData(),
              title: const Text('Reset data'),
              subtitle: const Text('Reset data anakan ke nol'),
              leading: const Icon(Icons.settings_backup_restore_rounded),
            ),
            const Divider(),

            // list tile estimate price
            ListTile(
              onTap: () => _showDialogDeleteData(),
              title: const Text('Hapus data'),
              subtitle: const Text('Menghapus data dari database'),
              leading: const Icon(Icons.delete_rounded),
            ),
          ],
        ),
      );

  void _showDialogChangeName() => showDialog(
      context: context,
      builder: (context) => ADialogTextField(
          title: 'Nama anakan',
          hintText: 'Masukkan nama anakan',
          textInputType: TextInputType.name,
          onClickOk: (text) {
            context.read<AChildBloc>().add(AChildChangeName(
                childKey: _childModel!.childKey!, childName: text));
          }));

  void _showDialogChangeBornDate() async {
    var _a = DateTime.parse(_childModel!.childBornDate!);
    var _selectedDate = await showDatePicker(
        context: context,
        initialDate: _a,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime.now());
    if (_selectedDate != null) {
      context.read<AChildBloc>().add(AChildChangeBornDate(
            childKey: _childModel!.childKey!,
            bornDate: _selectedDate.toString(),
          ));
    }
  }

  void _showDialogChangeWeight() {
    showDialog(
        context: context,
        builder: (context) => ADialogTextField(
            title: 'Berat anakan',
            hintText: 'Masukkan berat anakan',
            textInputType: TextInputType.number,
            onClickOk: (text) {
              context.read<AChildBloc>().add(AChildChangeWeight(
                    childKey: _childModel!.childKey!,
                    childWeight: text,
                  ));
            }));
  }

  void _showDialogResetData() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Reset data'),
              content: Text('Reset data ${_childModel!.childName!} ke nol?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal')),
                TextButton(
                    onPressed: () {
                      context.read<AChildBloc>().add(AChildResetData(
                          childKey: _childModel!.childKey!,
                          childName: _childModel!.childName!));
                      Navigator.pop(context);
                    },
                    child: const Text('Reset')),
              ],
            ));
  }

  void _showDialogDeleteData() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Hapus data'),
              content:
                  Text('Hapus data ${_childModel!.childName!} dari database?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal')),
                TextButton(
                    onPressed: () {
                      context.read<AChildBloc>().add(
                          AChildDeleteData(childKey: _childModel!.childKey!));
                      Navigator.pop(context);
                    },
                    child: const Text('Hapus')),
              ],
            ));
  }

  String _parsePassedDay() {
    var _a = DateTime.parse(_childModel!.childBornDate!);
    var _b = DateTime.now();
    var _c = _b.difference(_a).inDays;
    return '$_c';
  }
}
