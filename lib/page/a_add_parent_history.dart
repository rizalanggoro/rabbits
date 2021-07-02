import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rabbits/bloc/a_parent_history/a_parent_history_bloc.dart';
import 'package:rabbits/model/a_parent_history_model.dart';
import 'package:rabbits/util/util.dart';
import 'package:rabbits/view/a_card.dart';
import 'package:rabbits/view/app_bar_back_button.dart';
import 'package:rabbits/view/dialog/a_dialog_text_field.dart';

// ignore: use_key_in_widget_constructors
class AAddParentHistory extends StatefulWidget {
  static var tag = 'a-add-parent-history-page';

  final String? parentKey;
  final String? parentMarryDate;
  // ignore: use_key_in_widget_constructors
  const AAddParentHistory({
    this.parentKey,
    this.parentMarryDate,
  });
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AAddParentHistory> {
  @override
  Widget build(BuildContext context) {
    _init();

    return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<AParentHistoryBloc>()),
        ],
        child: Scaffold(
          appBar: AppBar(
            leading: AppBarBackButton(),
            title: const Text('Tambah riwayat'),
          ),
          body: _body,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _onClickDone(),
            icon: const Icon(Icons.done_rounded),
            label: const Text('Simpan'),
          ),
        ));
  }

  Util? _util;
  final ValueNotifier<DateTime> _valueNotifierDateTimeBorn =
      ValueNotifier(DateTime.now());
  final ValueNotifier<String> _valueNotifierChildCount = ValueNotifier('0');
  _init() {
    _util ??= Util()..init(context);
  }

  get _body => BlocBuilder<AParentHistoryBloc, AParentHistoryState>(
        builder: (context, state) {
          if (state is AParentHistoryOnAdd) {
            context
                .read<AParentHistoryBloc>()
                .add(AParentHistoryResetInitial());
            SchedulerBinding.instance!
                .addPostFrameCallback((timeStamp) => Navigator.pop(context));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _card1(),
              ],
            ),
          );
        },
      );

  _card1() => ACard(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        children: [
          // list tile marry date
          ListTile(
            leading: const Icon(Icons.today_rounded),
            title: const Text('Tanggal kawin'),
            subtitle: Text(
              _util!.parseDate(widget.parentMarryDate!, error: '-'),
            ),
          ),

          // list tile passed day
          ListTile(
            leading: const Icon(null),
            title: const Text('Hari terlampaui'),
            subtitle: ValueListenableBuilder(
              valueListenable: _valueNotifierDateTimeBorn,
              builder: (context, value, child) => Text(
                '${_parsePassedDay()} hari',
              ),
            ),
          ),
          const Divider(),

          // list tile born date
          ValueListenableBuilder(
            valueListenable: _valueNotifierDateTimeBorn,
            builder: (context, value, child) => ListTile(
              leading: const Icon(Icons.pets_rounded),
              title: const Text('Tanggal lahir'),
              subtitle: Text(_util!.parseDate(value.toString(), error: '-')),
              trailing: ElevatedButton(
                child: const Text('Ubah'),
                onPressed: () => _showDialogChangeDateTimeBorn(),
              ),
            ),
          ),
          const Divider(),

          // list tile child count
          ListTile(
            onTap: () => _showDialogChangeChildCount(),
            leading: const Icon(Icons.favorite_rounded),
            title: const Text('Jumlah anakan'),
            subtitle: ValueListenableBuilder(
                valueListenable: _valueNotifierChildCount,
                builder: (context, value, child) => Text('$value ekor')),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ));

  void _showDialogChangeDateTimeBorn() async {
    var _firstDate = DateTime.parse(widget.parentMarryDate!);
    var _selectedDate = await showDatePicker(
      context: context,
      initialDate: _valueNotifierDateTimeBorn.value,
      firstDate: _firstDate,
      lastDate: DateTime.now(),
    );
    if (_selectedDate != null) {
      _valueNotifierDateTimeBorn.value = _selectedDate;
    }
  }

  void _showDialogChangeChildCount() {
    showDialog(
        context: context,
        builder: (context) => ADialogTextField(
            title: 'Jumlah anakan',
            hintText: 'Masukkan jumlah anakan',
            textInputType: TextInputType.number,
            onClickOk: (text) {
              _valueNotifierChildCount.value = text;
            }));
  }

  void _onClickDone() {
    var _historyModel = AParentHistoryModel(
      key: _util!.generateKey,
      bornDate: _valueNotifierDateTimeBorn.value.toString(),
      childCount: _valueNotifierChildCount.value,
      marryDate: widget.parentMarryDate!,
      passedDay: _parsePassedDay().toString(),
      parentKey: widget.parentKey!,
    );
    context
        .read<AParentHistoryBloc>()
        .add(AParentHistoryAdd(parentHistoryModel: _historyModel));
  }

  int _parsePassedDay() {
    var _a = DateTime.parse(widget.parentMarryDate!);
    var _b = _valueNotifierDateTimeBorn.value;
    var _c = _b.difference(_a).inDays;
    return _c;
  }
}
