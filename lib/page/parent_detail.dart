import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rabbits/bloc/rabbit_parent/rabbit_parent_bloc.dart';
import 'package:rabbits/bloc/rabbit_parent/rabbit_parent_event.dart';
import 'package:rabbits/bloc/rabbit_parent/rabbit_parent_state.dart';
import 'package:rabbits/bloc/rabbit_parent_add_history/rabbit_parent_add_history_bloc.dart';
import 'package:rabbits/bloc/rabbit_parent_add_history/rabbit_parent_add_history_event.dart';
import 'package:rabbits/bloc/rabbit_parent_add_history/rabbit_parent_add_history_state.dart';
import 'package:rabbits/data/calendar_data.dart';
import 'package:rabbits/data/rabbit_parent_status.dart';
import 'package:rabbits/data/static_data.dart';
import 'package:rabbits/model/rabbit_parent_history_model.dart';
import 'package:rabbits/model/rabbit_parent_model.dart';
import 'package:rabbits/page/add_rabbit_parent_history.dart';
import 'package:rabbits/util/util.dart';
import 'package:rabbits/view/app_bar_back_button.dart';
import 'package:rabbits/view/dialog_text_field.dart';

// ignore: use_key_in_widget_constructors
class ParentDetail extends StatefulWidget {
  static var tag = 'parent-detail-page';
  final String? parentKey;
  final String? parentName;

  // ignore: use_key_in_widget_constructors
  const ParentDetail({this.parentKey, this.parentName});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ParentDetail> {
  @override
  Widget build(BuildContext context) {
    _init();

    return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<RabbitParentBloc>()),
          BlocProvider.value(value: context.read<RabbitParentAddHistoryBloc>()),
        ],
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: AppBarBackButton(),
            title: Text(_parentName!),
            actions: [
              IconButton(
                  onPressed: () => _showDialogChangeParentName(),
                  icon: const Icon(Icons.edit_rounded)),
              Container(width: 8),
            ],
          ),
          body: _body,
        ));
  }

  String? _parentName;
  Util? _util;
  _init() {
    _util ??= Util()..init(context);
    _parentName ??= widget.parentName!;

    //* get rabbit parent model from database
    context
        .read<RabbitParentBloc>()
        .add(GetRabbitParentByKey(parentKey: widget.parentKey!));

    // get all rabbit parent history from database
    context
        .read<RabbitParentAddHistoryBloc>()
        .add(GetAllRabbitParentHistory(parentKey: widget.parentKey!));
  }

  RabbitParentModel? _rabbitParentModel;
  DateTime? _dateTimeMarryDate;
  get _body => BlocBuilder<RabbitParentBloc, RabbitParentState>(
        builder: (context, state) {
          if (state is OnGetRabbitParentByKey) {
            _rabbitParentModel = state.rabbitParentModel;

            //* initalize data
            var _marryDateString = _rabbitParentModel!.marryDate!;
            if (_marryDateString.isNotEmpty) {
              _dateTimeMarryDate =
                  DateTime.parse(_rabbitParentModel!.marryDate!);
            } else {
              _dateTimeMarryDate = null;
            }
            _valueNotifierRabbitParentStatus.value =
                _rabbitParentModel!.status!.isEmpty
                    ? RabbitParentStatus.none
                    : RabbitParentStatus.contain;

            SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
              _textEditingControllerParentName.text =
                  _rabbitParentModel!.parentName!;
              _textEditingControllerParentName.selection =
                  TextSelection.fromPosition(TextPosition(
                      offset: _textEditingControllerParentName.text.length));
            });

            //* reset to initial state
            context.read<RabbitParentBloc>().add(ResetToInitial());
          } else if (state is OnChangeRabbitParentMarryDate) {
            var _a = state.marryDateTime;
            var _b = DateTime.parse(_a);
            _dateTimeMarryDate = _b;

            //* reset to initial state
            context.read<RabbitParentBloc>().add(ResetToInitial());
          } else if (state is OnChangeRabbitParentStatus) {
            _valueNotifierRabbitParentStatus.value = state.parentStatus.isEmpty
                ? RabbitParentStatus.none
                : RabbitParentStatus.contain;

            //* reset to initial state
            context.read<RabbitParentBloc>().add(ResetToInitial());
          } else if (state is OnChangeRabbitParentName) {
            var _a = state.parentName;
            _parentName = _a;

            //* reset to initial state
            context.read<RabbitParentBloc>().add(ResetToInitial());
          } else if (state is OnResetRabbitParent) {
            //* reset rabbit parent then get rabbit parent again by key
            var _parentKey = state.parentKey;
            context
                .read<RabbitParentBloc>()
                .add(GetRabbitParentByKey(parentKey: _parentKey));
          } else if (state is OnDeleteRabbitParentFromDatabase) {
            //* on delete rabbit parent from database
            //* reset to initial state
            context.read<RabbitParentBloc>().add(ResetToInitial());

            //* pop page
            SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            });
          }

          if (_rabbitParentModel != null) {
            //* initialize rabbit parent marry date
            var _isMarried = _dateTimeMarryDate != null;
            var _marryDate = '';
            if (_isMarried) {
              var _year = _dateTimeMarryDate?.year;
              var _month = CalendarData.month[_dateTimeMarryDate!.month - 1];
              var _day = _dateTimeMarryDate!.day;
              _marryDate = '$_day $_month $_year';
            }

            return SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 8),

                //? list tile married date
                ListTile(
                  leading: const Icon(Icons.today_rounded),
                  title: const Text('Tanggal kawin'),
                  subtitle: Text(
                    _isMarried ? _marryDate : 'Belum disetel',
                  ),
                  trailing: ElevatedButton(
                    child: const Text('Ubah'),
                    onPressed: () => _showDialogChangeMarryDate(),
                  ),
                ),
                ListTile(
                  leading: const Icon(null),
                  title: const Text('Hari terlampaui'),
                  subtitle: Text(
                    _isMarried
                        ? '${_getPassedDayCount(_dateTimeMarryDate!)} hari'
                        : 'Tidak dapat dikalkulasikan',
                  ),
                ),
                const Divider(),

                //? list tile born estimate
                ListTile(
                  leading: const Icon(Icons.pets_rounded),
                  title: const Text('Estimasi melahirkan'),
                  subtitle: Text(
                    _isMarried
                        ? '${_parseEstimateBorn(_getEstimeBorn(_dateTimeMarryDate ?? DateTime.now()))}'
                        : 'Tidak dapat dikalkulasikan',
                  ),
                ),
                const Divider(),

                //? list tile give box
                ListTile(
                  leading: const Icon(Icons.add_box_rounded),
                  title: const Text('Pemberian kotak melahirkan'),
                  subtitle: Text(
                    _isMarried
                        ? '${_getAddBoxDate(_getEstimeBorn(_dateTimeMarryDate ?? DateTime.now()))}'
                        : 'Tidak dapat dikalkulasikan',
                  ),
                ),
                const Divider(),

                //? list tile status
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: const Text('Status indukan'),
                  subtitle: Text(
                    _valueNotifierRabbitParentStatus.value ==
                            RabbitParentStatus.none
                        ? 'Tidak disetel'
                        : 'Mengandung',
                  ),
                  trailing: ElevatedButton(
                    child: const Text('Ubah'),
                    onPressed: () => _showDialogRabbitParentStatus(),
                  ),
                ),
                const Divider(),

                _tileOtherSetting(),
                _tileBornHistory(),
              ],
            ));
          } else {
            return const Center(child: Text('Tidak ada data'));
          }
        },
      );

  _tileOtherSetting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: Text(
            'Pengaturan lainnya',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
              fontSize: _util!.textTheme.bodyText1!.fontSize,
            ),
          ),
        ),

        //* list tile reset data to zero
        ListTile(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Reset data'),
                content: Text('Reset data ${_parentName!} ke nol?'),
                actions: [
                  TextButton(
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Batal')),
                  TextButton(
                    child: const Text('Reset'),
                    onPressed: () {
                      //* reset rabbit parent to zero
                      context.read<RabbitParentBloc>().add(
                          ResetRabbitParentToZero(
                              parentKey: _rabbitParentModel!.key!,
                              parentName: _parentName!));

                      //* dismiss dialog
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                  )
                ],
              ),
            );
          },
          leading: const Icon(Icons.restore_rounded),
          title: const Text('Reset data'),
          subtitle: const Text('Reset data indukan ke nol'),
        ),
        const Divider(),

        //* list tile delete rabbit parent from database
        ListTile(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text('Hapus data'),
                      content: Text(
                          'Hapus semua data $_parentName termasuk riwayat melahirkan dari database?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              //* dismiss dialog
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Batal')),
                        TextButton(
                          onPressed: () {
                            // delete rabbit parent history store ref
                            context
                                .read<RabbitParentAddHistoryBloc>()
                                .add(DeleteRabbitHistoryStoreRef(
                                  parentKey: _rabbitParentModel!.key!,
                                ));

                            //* delete rabbit parent from database
                            context
                                .read<RabbitParentBloc>()
                                .add(DeleteRabbitParentFromDatabase(
                                  parentKey: _rabbitParentModel!.key!,
                                ));

                            //* dismiss dialog
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Hapus'),
                        ),
                      ],
                    ));
          },
          leading: const Icon(Icons.delete_rounded),
          title: const Text('Hapus data'),
          subtitle: const Text('Hapus data indukan dari database'),
        ),
        const Divider(),
      ],
    );
  }

  _tileBornHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //? history
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 8),
          child: Text(
            'Riwayat melahirkan',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
              fontSize: _util!.textTheme.bodyText1!.fontSize,
            ),
          ),
        ),

        //? button add history
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
          ),
          child: OutlinedButton(
            onPressed: () {
              if (_dateTimeMarryDate != null) {
                var _marryDate = _dateTimeMarryDate.toString();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddRabbitParentHistory(
                      marryDate: _marryDate,
                      parentKey: _rabbitParentModel!.key!,
                    ),
                  ),
                );
              } else {
                var _snackbar = const SnackBar(
                  content: Text('Tanggal kawin belum disetel'),
                );
                ScaffoldMessenger.of(context).showSnackBar(_snackbar);
              }
            },
            child: const Text('Tambah riwayat'),
          ),
        ),
        Container(height: 16),

        //? list view born history
        _listViewBornHistory(),
      ],
    );
  }

  List<String> _listRabbitParentHistoryKey = [];
  List<RabbitParentHistoryModel> _listRabbitParentHistoryModel = [];
  _listViewBornHistory() =>
      BlocBuilder<RabbitParentAddHistoryBloc, RabbitParentAddHistoryState>(
        builder: (context, state) {
          if (state is OnGetAllRabbitParentHistory) {
            _listRabbitParentHistoryKey = state.listRabbitParentHistoryKey;
            _listRabbitParentHistoryModel = state.listRabbitParentHistoryModel;

            // reset to initial state
            context
                .read<RabbitParentAddHistoryBloc>()
                .add(ResetRabbitParentHistoryToInitial());
          } else if (state is OnAddedRabbitParentHistory) {
            var _model = state.rabbitParentHistoryModel;
            _listRabbitParentHistoryKey.insert(0, _model.key!);
            _listRabbitParentHistoryModel.insert(0, _model);

            // reset to initial state
            context
                .read<RabbitParentAddHistoryBloc>()
                .add(ResetRabbitParentHistoryToInitial());
          } else if (state is OnDeleteRabbitParentHistory) {
            var _historyKey = state.historyKey;
            var _index = _listRabbitParentHistoryKey.indexOf(_historyKey);
            if (_index != -1) {
              _listRabbitParentHistoryKey.removeAt(_index);
              _listRabbitParentHistoryModel.removeAt(_index);

              // reset to initial state
              context
                  .read<RabbitParentAddHistoryBloc>()
                  .add(ResetRabbitParentHistoryToInitial());
            }
          }

          if (_listRabbitParentHistoryKey.isNotEmpty) {
            return ListView.builder(
              itemBuilder: (context, index) {
                var _rabbitParentHistoryModel =
                    _listRabbitParentHistoryModel[index];

                // parse born date
                var _aa = DateTime.parse(_rabbitParentHistoryModel.bornDate!);
                var _bornDate =
                    '${_aa.day} ${CalendarData.month[_aa.month - 1]} ${_aa.year}';

                // parse marry date
                var _ab = DateTime.parse(_rabbitParentHistoryModel.marryDate!);
                var _marryDate =
                    '${_ab.day} ${CalendarData.month[_ab.month - 1]} ${_ab.year}';

                var _isLast = index == _listRabbitParentHistoryKey.length - 1;

                return Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      title: Text(_bornDate),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('Tanggal kawin : $_marryDate\n'
                            'Jumlah anakan : ${_rabbitParentHistoryModel.childCount} ekor\n'
                            'Hari terlampaui : ${_rabbitParentHistoryModel.dayPassedCount} hari'),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_rounded),
                        onPressed: () {
                          var _parentKey = widget.parentKey;
                          if (_parentKey != null) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Hapus riwayat'),
                                content: Text(
                                    'Hapus riwayat $_bornDate dari database?'),
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
                                        // delete rabbit parent history from database
                                        context
                                            .read<RabbitParentAddHistoryBloc>()
                                            .add(DeleteRabbitParentHistory(
                                              parentKey: _parentKey,
                                              historyKey:
                                                  _rabbitParentHistoryModel
                                                      .key!,
                                            ));

                                        if (Navigator.canPop(context)) {
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text('Hapus')),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    if (!_isLast) const Divider(),
                    if (_isLast) Container(height: 16),
                  ],
                );
              },
              itemCount: _listRabbitParentHistoryKey.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            );
          } else {
            return const Center(
                child: Padding(
              child: Text('Riwayat tidak ditemukan'),
              padding: EdgeInsets.only(bottom: 16),
            ));
          }
        },
      );

  _getPassedDayCount(DateTime dateTime) {
    var _a = DateTime.now();
    var _b = _a.difference(dateTime).inDays;
    return '$_b';
  }

  _getEstimeBorn(DateTime dateTime) {
    var _a = dateTime;
    var _b = int.parse(StaticData.estimateBorn ?? '0');
    var _c = DateTime(_a.year, _a.month, (_a.day + _b));

    return _c;
  }

  _getAddBoxDate(DateTime dateTimeBorn) {
    var _a = StaticData.addBox;
    var _b = int.parse(_a ?? '0');
    var _c = dateTimeBorn;
    var _d = DateTime(_c.year, _c.month, (_c.day - _b));

    var _year = _d.year;
    var _month = CalendarData.month[_d.month - 1];
    var _day = _d.day;
    return '$_day $_month $_year';
  }

  _parseEstimateBorn(DateTime dateTime) {
    var _year = dateTime.year;
    var _month = CalendarData.month[dateTime.month - 1];
    var _day = dateTime.day;
    return '$_day $_month $_year';
  }

  final ValueNotifier<RabbitParentStatus> _valueNotifierRabbitParentStatus =
      ValueNotifier(RabbitParentStatus.none);
  _showDialogRabbitParentStatus() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Status indukan'),
              contentPadding: const EdgeInsets.only(top: 8),
              content: ValueListenableBuilder(
                builder: (context, value, child) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioListTile<RabbitParentStatus>(
                      title: const Text('Tidak disetel'),
                      value: RabbitParentStatus.none,
                      groupValue: _valueNotifierRabbitParentStatus.value,
                      onChanged: (value) => _valueNotifierRabbitParentStatus
                          .value = RabbitParentStatus.none,
                    ),
                    RadioListTile<RabbitParentStatus>(
                      title: const Text('Mengandung'),
                      value: RabbitParentStatus.contain,
                      groupValue: _valueNotifierRabbitParentStatus.value,
                      onChanged: (value) => _valueNotifierRabbitParentStatus
                          .value = RabbitParentStatus.contain,
                    ),
                  ],
                ),
                valueListenable: _valueNotifierRabbitParentStatus,
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
                      var _a = _valueNotifierRabbitParentStatus.value;
                      var _b = _a == RabbitParentStatus.none ? '' : 'contain';

                      //* change parent status
                      context.read<RabbitParentBloc>().add(
                          ChangeRabbitParentStatus(
                              parentKey: _rabbitParentModel!.key!,
                              parentStatus: _b));

                      //* dismiss dialog
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Simpan')),
              ],
            ));
  }

  _showDialogChangeMarryDate() async {
    var _a = DateTime.now();
    var _b = DateTime(_a.year - 1);
    var _c = await showDatePicker(
      context: context,
      initialDate: _dateTimeMarryDate ?? _a,
      firstDate: _b,
      lastDate: _a,
    );

    if (_c != null) {
      //* change rabbit parent marry date and save it to database
      context.read<RabbitParentBloc>().add(ChangeRabbitParentMarryDate(
            parentKey: _rabbitParentModel!.key!,
            marryDateTime: _c.toString(),
          ));
    }
  }

  final TextEditingController _textEditingControllerParentName =
      TextEditingController();
  _showDialogChangeParentName() {
    showDialog(
      context: context,
      builder: (context) => DialogTextField(
          title: 'Nama indukan',
          hintText: 'Masukkan nama indukan',
          textEditingController: _textEditingControllerParentName,
          onClickCancel: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          onClickSave: () {
            var _a = _textEditingControllerParentName.text;
            if (_a.isNotEmpty) {
              //* change rabbit parent name
              context.read<RabbitParentBloc>().add(ChangeRabbitParentName(
                    parentKey: _rabbitParentModel!.key!,
                    parentName: _a,
                  ));

              //* dismiss dialog
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            }
          },
          textInputType: TextInputType.name),
    );
  }
}
