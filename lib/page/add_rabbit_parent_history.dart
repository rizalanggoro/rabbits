import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rabbits/bloc/rabbit_parent_add_history/rabbit_parent_add_history_bloc.dart';
import 'package:rabbits/bloc/rabbit_parent_add_history/rabbit_parent_add_history_event.dart';
import 'package:rabbits/bloc/rabbit_parent_add_history/rabbit_parent_add_history_state.dart';
import 'package:rabbits/data/calendar_data.dart';
import 'package:rabbits/model/rabbit_parent_history_model.dart';
import 'package:rabbits/util/util.dart';
import 'package:rabbits/view/app_bar_back_button.dart';
import 'package:rabbits/view/dialog_text_field.dart';

// ignore: use_key_in_widget_constructors
class AddRabbitParentHistory extends StatefulWidget {
  static var tag = 'add-rabbit-parent-history-page';

  final String? parentKey;
  final String? marryDate;

  // ignore: use_key_in_widget_constructors
  const AddRabbitParentHistory({
    this.parentKey,
    this.marryDate,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AddRabbitParentHistory> {
  @override
  Widget build(BuildContext context) {
    _init();

    return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<RabbitParentAddHistoryBloc>()),
        ],
        child: Scaffold(
          appBar: AppBar(
            leading: AppBarBackButton(),
            title: const Text('Tambah riwayat melahirkan'),
          ),
          body: _body,
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.done_rounded),
            onPressed: () => _onClickDone(),
          ),
        ));
  }

  Util? _util;
  bool _initData = false;
  _init() {
    _util ??= Util()..init(context);
    if (!_initData) {
      // reset born date to today
      context
          .read<RabbitParentAddHistoryBloc>()
          .add(RabbitParentHistoryResetDefaultValue());
      _initData = true;
    }
  }

  _onClickDone() {
    var _parentKey = widget.parentKey;
    var _marryDate = widget.marryDate;
    if (_parentKey != null && _marryDate != null) {
      var _model = RabbitParentHistoryModel(
        key: DateTime.now().toString(),
        parentKey: _parentKey,
        bornDate: _dateTimeBorn.toString(),
        dayPassedCount: _parsePassedDayCount(),
        childCount: _childCount,
        marryDate: _marryDate,
      );

      // add rabbit parent history to database
      context
          .read<RabbitParentAddHistoryBloc>()
          .add(RabbitParentHistoryAddModel(
            parentKey: _parentKey,
            rabbitParentHistoryModel: _model,
          ));
    }
  }

  DateTime _dateTimeBorn = DateTime.now();
  String _childCount = '-';
  final TextEditingController _textEditingControllerChildCount =
      TextEditingController();
  get _body =>
      BlocBuilder<RabbitParentAddHistoryBloc, RabbitParentAddHistoryState>(
          builder: (context, state) {
        if (state is OnChangeRabbitParentHistoryBornDate) {
          var _stringDateTimeBorn = state.dateTimeBorn;
          _dateTimeBorn = DateTime.parse(_stringDateTimeBorn);

          // reset to initial state
          context
              .read<RabbitParentAddHistoryBloc>()
              .add(ResetRabbitParentHistoryToInitial());
        } else if (state is OnChangeRabbitParentHistoryChildCount) {
          _childCount = state.childCount;

          // reset to initial state
          context
              .read<RabbitParentAddHistoryBloc>()
              .add(ResetRabbitParentHistoryToInitial());
        } else if (state is OnResetDefaultValueRabbitParentHistory) {
          _dateTimeBorn = DateTime.now();
          _childCount = '-';

          // reset to initial state
          context
              .read<RabbitParentAddHistoryBloc>()
              .add(ResetRabbitParentHistoryToInitial());
        } else if (state is OnAddedRabbitParentHistory) {
          SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
            // reset to initial state
            context
                .read<RabbitParentAddHistoryBloc>()
                .add(ResetRabbitParentHistoryToInitial());

            // pop page
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          });
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 8),

              // list tile marry date
              ListTile(
                leading: const Icon(Icons.today_rounded),
                title: const Text('Tanggal kawin'),
                subtitle: Text(_parseMarryDate()),
              ),

              // list tile passed day count
              ListTile(
                leading: const Icon(null),
                title: const Text('Hari terlampaui'),
                subtitle: Text('${_parsePassedDayCount()} hari'),
              ),
              const Divider(),

              // list tile born date
              ListTile(
                leading: const Icon(Icons.pets_rounded),
                title: const Text('Tanggal lahir'),
                subtitle: Text(_parseBornDate()),
                trailing: ElevatedButton(
                  child: const Text('Ubah'),
                  onPressed: () => _showDialogChangeBornDate(),
                ),
              ),
              const Divider(),

              // list tile child count
              ListTile(
                onTap: () {
                  // show dialog text field
                  showDialog(
                      context: context,
                      builder: (context) => DialogTextField(
                            title: 'Jumlah anakan',
                            hintText: 'Masukkan jumlah anakan',
                            textEditingController:
                                _textEditingControllerChildCount,
                            onClickCancel: () {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            },
                            onClickSave: () {
                              var _a = _textEditingControllerChildCount.text;
                              if (_a.isNotEmpty) {
                                // change rabbit parent child count
                                context.read<RabbitParentAddHistoryBloc>().add(
                                    RabbitParentHistoryChangeChildCount(
                                        childCount: _a));

                                // dismiss dialog
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                }
                              }
                            },
                            textInputType: TextInputType.number,
                          ));
                },
                leading: const Icon(Icons.format_list_numbered_rounded),
                title: const Text('Jumlah anakan'),
                subtitle: Text(_childCount),
                trailing: const Icon(Icons.chevron_right_rounded),
              ),
              Container(height: 16),
            ],
          ),
        );
      });

  _showDialogChangeBornDate() async {
    var _marryDateString = widget.marryDate;
    if (_marryDateString != null) {
      var _marryDate = DateTime.parse(_marryDateString);
      var _lastDate = DateTime.now();
      var _initialDate = _dateTimeBorn;

      var _selectedDate = await showDatePicker(
          context: context,
          initialDate: _initialDate,
          firstDate: _marryDate,
          lastDate: _lastDate);

      if (_selectedDate != null) {
        // change date time born by bloc
        context.read<RabbitParentAddHistoryBloc>().add(
            RabbitParentHistoryChangeBornDate(
                dateTimeBorn: _selectedDate.toString()));
      }
    }
  }

  String _parseBornDate() {
    var _year = _dateTimeBorn.year;
    var _month = CalendarData.month[_dateTimeBorn.month - 1];
    var _day = _dateTimeBorn.day;
    return '$_day $_month $_year';
  }

  String _parsePassedDayCount() {
    var _a = widget.marryDate;
    if (_a != null) {
      var _b = DateTime.parse(_a);
      var _c = _dateTimeBorn.difference(_b);
      var _d = _c.inDays;
      return '$_d';
    }
    return 'tidak dapat dikalkulasikan';
  }

  String _parseMarryDate() {
    var _a = widget.marryDate;
    if (_a != null) {
      var _b = DateTime.parse(_a);
      var _year = _b.year;
      var _month = CalendarData.month[_b.month - 1];
      var _day = _b.day;
      return '$_day $_month $_year';
    } else {
      return '';
    }
  }
}
