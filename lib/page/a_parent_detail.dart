import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rabbits/bloc/a_parent/a_parent_bloc.dart';
import 'package:rabbits/bloc/a_parent_history/a_parent_history_bloc.dart';
import 'package:rabbits/data/a_static.dart';
import 'package:rabbits/data/calendar_data.dart';
import 'package:rabbits/model/a_parent_history_model.dart';
import 'package:rabbits/model/a_parent_model.dart';
import 'package:rabbits/page/a_add_parent_history.dart';
import 'package:rabbits/util/util.dart';
import 'package:rabbits/view/a_card.dart';
import 'package:rabbits/view/app_bar_back_button.dart';
import 'package:rabbits/view/dialog/a_dialog_text_field.dart';

// ignore: use_key_in_widget_constructors
class AParentDetail extends StatefulWidget {
  static var tag = 'a-parent-detail-page';

  final AParentModel? parentModel;
  // ignore: use_key_in_widget_constructors
  const AParentDetail({
    this.parentModel,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AParentDetail> {
  @override
  Widget build(BuildContext context) {
    _init();

    return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<AParentBloc>()),
          BlocProvider.value(value: context.read<AParentHistoryBloc>()),
        ],
        child: BlocBuilder<AParentBloc, AParentState>(
          builder: (context, state) {
            if (state is AParentOnChangeMarryDate) {
              var _parentMarryDate = state.parentMarryDate;
              widget.parentModel!.parentMarryDate = _parentMarryDate;
              context.read<AParentBloc>().add(AParentResetToInitial());
            } else if (state is AParentOnChangeName) {
              var _parentName = state.parentName;
              widget.parentModel!.parentName = _parentName;
              context.read<AParentBloc>().add(AParentResetToInitial());
            } else if (state is AParentOnChangeStatus) {
              var _parentKey = state.parentKey;
              var _parentStatus = state.parentStatus;
              widget.parentModel!.parentStatus = _parentStatus;
              if (_parentStatus.isNotEmpty) {
                // move to pregnant list
                var _index = AStatic.listParentKey.indexOf(_parentKey);
                if (_index != -1) {
                  AStatic.listParentKey.removeAt(_index);
                  AStatic.listParentModel.removeAt(_index);
                  AStatic.listPregnantParentKey.add(_parentKey);
                  AStatic.listPregnantParentKey.sort();

                  var _index2 =
                      AStatic.listPregnantParentKey.indexOf(_parentKey);
                  if (_index2 != -1) {
                    AStatic.listPregnantParentModel.insert(
                      _index2,
                      widget.parentModel!,
                    );
                  }
                }
              } else {
                // move to list
                var _index = AStatic.listPregnantParentKey.indexOf(_parentKey);
                if (_index != -1) {
                  AStatic.listPregnantParentKey.removeAt(_index);
                  AStatic.listPregnantParentModel.removeAt(_index);
                  AStatic.listParentKey.add(_parentKey);
                  AStatic.listParentKey.sort();

                  var _index2 = AStatic.listParentKey.indexOf(_parentKey);
                  if (_index2 != -1) {
                    AStatic.listParentModel.insert(
                      _index2,
                      widget.parentModel!,
                    );
                  }
                }
              }
              context.read<AParentBloc>().add(AParentResetToInitial());
            } else if (state is AParentOnResetData) {
              var _parentKey = widget.parentModel!.parentKey!;
              var _parentStatus = widget.parentModel!.parentStatus!;
              if (_parentStatus.isNotEmpty) {
                // move parent to list first
                var _index = AStatic.listPregnantParentKey.indexOf(_parentKey);
                if (_index != -1) {
                  AStatic.listPregnantParentKey.removeAt(_index);
                  AStatic.listPregnantParentModel.removeAt(_index);
                  AStatic.listParentKey.add(_parentKey);
                  AStatic.listParentKey.sort();

                  var _index2 = AStatic.listParentKey.indexOf(_parentKey);
                  if (_index2 != -1) {
                    AStatic.listParentModel.insert(
                      _index2,
                      widget.parentModel!,
                    );
                  }
                }
              }
              widget.parentModel!.parentMarryDate = '';
              widget.parentModel!.parentStatus = '';
              context.read<AParentBloc>().add(AParentResetToInitial());
            } else if (state is AParentOnDeleteRecord) {
              var _parentKey = state.parentKey;
              var _parentStatus = widget.parentModel!.parentStatus!;
              if (_parentStatus.isNotEmpty) {
                var _index = AStatic.listPregnantParentKey.indexOf(_parentKey);
                if (_index != -1) {
                  AStatic.listPregnantParentKey.removeAt(_index);
                  AStatic.listPregnantParentModel.removeAt(_index);
                }
              } else {
                var _index = AStatic.listParentKey.indexOf(_parentKey);
                if (_index != -1) {
                  AStatic.listParentKey.removeAt(_index);
                  AStatic.listParentModel.removeAt(_index);
                }
              }
              context.read<AParentBloc>().add(AParentResetToInitial());

              // pop page
              SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
                Navigator.pop(context);
              });
            }

            return Scaffold(
              appBar: AppBar(
                leading: AppBarBackButton(),
                title: Text(widget.parentModel!.parentName!),
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
  _init() {
    _util ??= Util()..init(context);
  }

  get _body => SingleChildScrollView(
        child: Column(
          children: [
            _card1(),
            _card2(),
            _card3(),
          ],
        ),
      );

  _card1() => ACard(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Column(
          children: [
            // list tile marry date
            ListTile(
              title: const Text('Tanggal kawin'),
              subtitle: Text(_util!.parseDate(
                widget.parentModel!.parentMarryDate!,
                error: 'Belum disetel',
              )),
              leading: const Icon(Icons.today_rounded),
              trailing: ElevatedButton(
                onPressed: () => _showDialogChangeMarryDate(),
                child: const Text('Ubah'),
              ),
            ),
            const Divider(indent: 56 + 16),

            // list tile passed day
            ListTile(
              title: const Text('Hari terlampaui'),
              subtitle: Text(_parsePassedDay()),
              leading: const Icon(null),
            ),
            const Divider(),

            // list tile estimate born
            ListTile(
              title: const Text('Estimasi melahirkan'),
              subtitle: Text(_parseEstimateBorn()),
              leading: const Icon(Icons.pets_rounded),
            ),
            const Divider(),

            // list tile add box
            ListTile(
              title: const Text('Pemberian kotak melahirkan'),
              subtitle: Text(_parseAddBox()),
              leading: const Icon(Icons.add_box_rounded),
            ),
            const Divider(),

            // list tile parent status
            ListTile(
              title: const Text('Status indukan'),
              subtitle: Text(
                widget.parentModel!.parentStatus!.isEmpty
                    ? 'Tidak disetel'
                    : 'Mengandung',
              ),
              leading: const Icon(Icons.info_outline_rounded),
              trailing: ElevatedButton(
                onPressed: () => _showDialogChangeStatus(),
                child: const Text('Ubah'),
              ),
            ),
          ],
        ),
      );

  _card2() => ACard(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            child: Text(
              'Pengaturan lainnya',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
            padding: const EdgeInsets.only(left: 16, bottom: 8),
          ),

          // list tile reset parent
          ListTile(
            onTap: () => _showDialogResetData(),
            title: const Text('Reset data'),
            subtitle: const Text('Reset data indukan ke nol'),
            leading: const Icon(Icons.settings_backup_restore_rounded),
          ),
          const Divider(),

          // list tile delete parent
          ListTile(
            onTap: () => _showDialogDeleteData(),
            title: const Text('Hapus data indukan'),
            subtitle: const Text('Hapus data indukan dari database'),
            leading: const Icon(Icons.delete_rounded),
          ),
        ],
      ));

  List<String> _listParentHistoryKey = [];
  List<AParentHistoryModel> _listParentHistoryModel = [];
  _card3() => ACard(
        margin: const EdgeInsets.only(top: 16, bottom: 16),
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              child: Text(
                'Riwayat melahirkan',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              padding: const EdgeInsets.only(left: 16, bottom: 16),
            ),

            // button add history
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: OutlinedButton(
                child: const Text('Tambah riwayat'),
                onPressed: () {
                  var _parentKey = widget.parentModel!.parentKey!;
                  var _parentMarryDate = widget.parentModel!.parentMarryDate!;
                  if (_parentMarryDate.isNotEmpty) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AAddParentHistory(
                                  parentKey: _parentKey,
                                  parentMarryDate: _parentMarryDate,
                                )));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Tanggal kawin belum disetel')));
                  }
                },
              ),
            ),

            // list view born history
            FutureBuilder(
              future: AParentHistoryBloc()
                  .getAll(parentKey: widget.parentModel!.parentKey!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var _mapList = snapshot.data! as Map<String, dynamic>;
                  _listParentHistoryKey =
                      _mapList[AParentHistoryBloc.listHistoryKeyKey];
                  _listParentHistoryModel =
                      _mapList[AParentHistoryBloc.listHistoryModelKey];

                  return BlocBuilder<AParentHistoryBloc, AParentHistoryState>(
                    builder: (context, state) {
                      if (state is AParentHistoryOnAdd) {
                        var _model = state.parentHistoryModel;
                        _listParentHistoryModel.insert(0, _model);
                        context
                            .read<AParentHistoryBloc>()
                            .add(AParentHistoryResetInitial());
                      } else if (state is AParentHistoryOnDelete) {
                        var _historyKey = state.historyKey;
                        var _index = _listParentHistoryKey.indexOf(_historyKey);
                        if (_index != -1) {
                          _listParentHistoryKey.removeAt(_index);
                          _listParentHistoryModel.removeAt(_index);
                        }
                        context
                            .read<AParentHistoryBloc>()
                            .add(AParentHistoryResetInitial());
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.only(top: 16),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => Column(
                          children: [
                            _listTileBornHistory(
                                index, _listParentHistoryModel[index]),
                            if (index != (_listParentHistoryModel.length - 1))
                              const Divider(),
                          ],
                        ),
                        itemCount: _listParentHistoryModel.length,
                      );
                    },
                  );
                } else {
                  return Container(height: 8);
                }
              },
            )
          ],
        ),
      );

  _listTileBornHistory(index, AParentHistoryModel model) => ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(_util!.parseDate(model.bornDate!)),
        subtitle: Text(
          'Tanggal kawin : ${_util!.parseDate(model.marryDate!)}\n'
          'Jumlah anakan : ${model.childCount} ekor\n'
          'Hari terlampaui : ${model.passedDay} hari',
        ),
        trailing: IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text('Hapus riwayat'),
                      content: Text(
                        'Hapus riwayat ${_util!.parseDate(model.bornDate!)} dari database?',
                      ),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Batal')),
                        TextButton(
                            onPressed: () {
                              context.read<AParentHistoryBloc>().add(
                                  AParentHistoryDelete(
                                      parentKey: widget.parentModel!.parentKey!,
                                      historyKey: model.key!));
                              Navigator.pop(context);
                            },
                            child: const Text('Hapus')),
                      ],
                    ));
          },
          icon: const Icon(Icons.delete_rounded),
        ),
      );

  void _showDialogChangeName() {
    showDialog(
        context: context,
        builder: (context) => ADialogTextField(
            title: 'Nama indukan',
            hintText: 'Masukkan nama indukan',
            textInputType: TextInputType.name,
            onClickOk: (text) {
              context.read<AParentBloc>().add(AParentChangeName(
                  parentKey: widget.parentModel!.parentKey!, parentName: text));
            }));
  }

  void _showDialogChangeMarryDate() async {
    var _initialDate = DateTime.now();
    var _parentModelMarryDate = widget.parentModel!.parentMarryDate!;
    if (_parentModelMarryDate.isNotEmpty) {
      _initialDate = DateTime.parse(_parentModelMarryDate);
    }

    var _selectedDate = await showDatePicker(
      context: context,
      initialDate: _initialDate,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
    );

    if (_selectedDate != null) {
      var _parentKey = widget.parentModel!.parentKey!;
      context.read<AParentBloc>().add(AParentChangeMarryDate(
            parentKey: _parentKey,
            parentMarryDate: _selectedDate.toString(),
          ));
    }
  }

  void _showDialogChangeStatus() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Status indukan'),
              contentPadding: const EdgeInsets.only(top: 8, bottom: 8),
              content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 24),
                      onTap: () {
                        context.read<AParentBloc>().add(AParentChangeStatus(
                            parentKey: widget.parentModel!.parentKey!,
                            parentStatus: ''));
                        Navigator.pop(context);
                      },
                      title: const Text('Tidak disetel'),
                    ),
                    ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 24),
                      onTap: () {
                        context.read<AParentBloc>().add(AParentChangeStatus(
                            parentKey: widget.parentModel!.parentKey!,
                            parentStatus: 'pregnant'));
                        Navigator.pop(context);
                      },
                      title: const Text('Mengandung'),
                    ),
                  ]),
            ));
  }

  void _showDialogResetData() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Reset data'),
              content:
                  Text('Reset data ${widget.parentModel!.parentName!} ke nol?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal')),
                TextButton(
                    onPressed: () {
                      context.read<AParentBloc>().add(AParentResetData(
                            parentKey: widget.parentModel!.parentKey!,
                            parentName: widget.parentModel!.parentName!,
                          ));
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
              content: Text(
                  'Hapus data ${widget.parentModel!.parentName!} termasuk seluruh riwayat dari database?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal')),
                TextButton(
                    onPressed: () {
                      context.read<AParentBloc>().add(AParentDeleteRecord(
                          parentKey: widget.parentModel!.parentKey!));
                      Navigator.pop(context);
                    },
                    child: const Text('Hapus')),
              ],
            ));
  }

  String _parsePassedDay() {
    var _parentMarryDate = widget.parentModel!.parentMarryDate!;
    if (_parentMarryDate.isNotEmpty) {
      var _dateTimeToday = DateTime.now();
      var _dateTimeMarryDate = DateTime.parse(_parentMarryDate);
      var _difference = _dateTimeToday.difference(_dateTimeMarryDate).inDays;
      return '$_difference hari';
    } else {
      return 'Tidak dapat dikalkulasikan';
    }
  }

  String _parseEstimateBorn() {
    var _parentMarryDate = widget.parentModel!.parentMarryDate!;
    if (_parentMarryDate.isNotEmpty) {
      var _estimateBorn = int.parse(AStatic.parentEstimateBorn);
      var _dateTimeMarryDate = DateTime.parse(_parentMarryDate);
      var _dateTimeEstimate = DateTime(
        _dateTimeMarryDate.year,
        _dateTimeMarryDate.month,
        _dateTimeMarryDate.day + _estimateBorn,
      );

      var _year = _dateTimeEstimate.year;
      var _month = CalendarData.month[_dateTimeEstimate.month - 1];
      var _day = _dateTimeEstimate.day;
      var _weekDay = CalendarData.days[_dateTimeEstimate.weekday];
      return '$_weekDay, $_day $_month $_year';
    } else {
      return 'Tidak dapat dikalkulasikan';
    }
  }

  String _parseAddBox() {
    var _parentMarryDate = widget.parentModel!.parentMarryDate!;
    if (_parentMarryDate.isNotEmpty) {
      var _addBox = int.parse(AStatic.parentAddBox);
      var _dateTimeMarryDate = DateTime.parse(_parentMarryDate);
      var _dateTimeEstimate = DateTime(
        _dateTimeMarryDate.year,
        _dateTimeMarryDate.month,
        _dateTimeMarryDate.day - _addBox,
      );

      var _year = _dateTimeEstimate.year;
      var _month = CalendarData.month[_dateTimeEstimate.month - 1];
      var _day = _dateTimeEstimate.day;
      var _weekDay = CalendarData.days[_dateTimeEstimate.weekday];
      return '$_weekDay, $_day $_month $_year';
    } else {
      return 'Tidak dapat dikalkulasikan';
    }
  }
}
