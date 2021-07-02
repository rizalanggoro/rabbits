import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rabbits/bloc/rabbit_parent/rabbit_parent_bloc.dart';
import 'package:rabbits/bloc/rabbit_parent/rabbit_parent_event.dart';
import 'package:rabbits/bloc/rabbit_parent/rabbit_parent_state.dart';
import 'package:rabbits/data/calendar_data.dart';
import 'package:rabbits/model/rabbit_parent_model.dart';
import 'package:rabbits/page/parent_detail.dart';
import 'package:rabbits/util/util.dart';
import 'package:rabbits/view/app_bar_back_button.dart';
import 'package:rabbits/view/dialog_text_field.dart';

// ignore: use_key_in_widget_constructors
class RabbitsParent extends StatefulWidget {
  static var tag = 'rabbits-parent-page';

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<RabbitsParent> {
  @override
  Widget build(BuildContext context) {
    _init();

    return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<RabbitParentBloc>()),
        ],
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: AppBarBackButton(),
            title: const Text('Indukan kelinci'),
          ),
          floatingActionButton: FloatingActionButton.extended(
              icon: const Icon(Icons.add_rounded),
              onPressed: () => _showDialogAddParent(),
              label: const Text('Tambah indukan')),
          body: _body,
        ));
  }

  final TextEditingController _textEditingControllerAddParentName =
      TextEditingController();
  _showDialogAddParent() {
    showDialog(
      context: context,
      builder: (context) => DialogTextField(
        title: 'Tambah indukan',
        hintText: 'Masukkan nama indukan',
        textEditingController: _textEditingControllerAddParentName,
        onClickCancel: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
        onClickSave: () {
          var _parentName = _textEditingControllerAddParentName.text;
          if (_parentName.isNotEmpty) {
            var _a = RabbitParentModel(
              key: DateTime.now().toString(),
              marryDate: '',
              parentName: _parentName,
              status: '',
            );

            //* add rabbit child model to database
            context
                .read<RabbitParentBloc>()
                .add(AddRabbitParent(rabbitParentModel: _a));

            //* reset text editing controller
            _textEditingControllerAddParentName.text = '';

            //* dismiss dialog
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          }
        },
        textInputType: TextInputType.name,
      ),
    );
  }

  Util? _util;
  _init() {
    _util ??= Util()..init(context);

    //* get all rabbit parent from database
    context.read<RabbitParentBloc>().add(GetAllRabbitParent());
  }

  List<RabbitParentModel> _listRabbitParentModel = [];
  List<String> _listRabbitParentKey = [];
  get _body => BlocBuilder<RabbitParentBloc, RabbitParentState>(
        builder: (context, state) {
          if (state is OnAddedRabbitParent) {
            var _a = state.rabbitParentModel;
            //* add model to list
            _listRabbitParentModel.add(_a);
            _listRabbitParentKey.add(_a.key!);

            //* reset state to initial
            context.read<RabbitParentBloc>().add(ResetToInitial());
          } else if (state is OnGetAllRabbitParentCompleted) {
            //* on get all rabbit parent completed
            //* insert to array list
            _listRabbitParentModel = state.listRabbitParentModel;
            _listRabbitParentKey = state.listRabbitParentKey;

            //* reset to initial state
            context.read<RabbitParentBloc>().add(ResetToInitial());
          } else if (state is OnChangeRabbitParentMarryDate) {
            var _parentKey = state.parentKey;
            var _index = _listRabbitParentKey.indexOf(_parentKey);
            if (_index != -1) {
              //* get rabbit parent model from array
              var _rabbitParentModel = _listRabbitParentModel[_index];

              //* change rabbit parent marry date
              _rabbitParentModel.marryDate = state.marryDateTime;

              //* put back rabbit parent model to array
              _listRabbitParentModel.removeAt(_index);
              _listRabbitParentModel.insert(_index, _rabbitParentModel);

              //* reset to initial state
              context.read<RabbitParentBloc>().add(ResetToInitial());
            }
          } else if (state is OnChangeRabbitParentStatus) {
            var _parentKey = state.parentKey;
            var _index = _listRabbitParentKey.indexOf(_parentKey);
            if (_index != -1) {
              //* get rabbit parent model from array
              var _model = _listRabbitParentModel[_index];

              //* change rabbit parent status in model
              _model.status = state.parentStatus;

              //* push to array
              _listRabbitParentModel.removeAt(_index);
              _listRabbitParentModel.insert(_index, _model);

              //* reset to initial state
              context.read<RabbitParentBloc>().add(ResetToInitial());
            }
          } else if (state is OnChangeRabbitParentName) {
            var _parentKey = state.parentKey;
            var _index = _listRabbitParentKey.indexOf(_parentKey);
            if (_index != -1) {
              //* get rabbit parent model from array
              var _model = _listRabbitParentModel[_index];

              //* change rabbit parent name in model
              _model.parentName = state.parentName;

              //* push to array
              _listRabbitParentModel.removeAt(_index);
              _listRabbitParentModel.insert(_index, _model);

              //* reset to initial state
              context.read<RabbitParentBloc>().add(ResetToInitial());
            }
          } else if (state is OnDeleteRabbitParentFromDatabase) {
            //* on delete rabbit parent from database
            //* delete rabbit parent model and key from array
            var _parentKey = state.parentKey;
            var _index = _listRabbitParentKey.indexOf(_parentKey);
            if (_index != -1) {
              _listRabbitParentModel.removeAt(_index);
              _listRabbitParentKey.removeAt(_index);
            }

            //* reset to initial state
            context.read<RabbitParentBloc>().add(ResetToInitial());
          }

          if (_listRabbitParentModel.isNotEmpty) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  //? list view rabbit parent
                  ListView.builder(
                    itemBuilder: (context, index) =>
                        _listItemRabbitParent(index, state),
                    itemCount: _listRabbitParentKey.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Tidak ada data'));
          }
        },
      );

  _listItemRabbitParent(index, state) {
    var _rabbitParentModel = _listRabbitParentModel[index];

    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
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
                    builder: (context) => ParentDetail(
                          parentKey: _rabbitParentModel.key,
                          parentName: _rabbitParentModel.parentName,
                        )));
          },
          child: Container(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_rabbitParentModel.status!.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(.16),
                    ),
                    child: Text(
                      'Mengandung',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                Text(
                  _rabbitParentModel.parentName!,
                  style: TextStyle(
                    fontSize: _util!.textTheme.subtitle1!.fontSize,
                  ),
                ),
                Text(
                  'Tanggal kawin: ${_getRabbitParentMarryDate(_rabbitParentModel.marryDate ?? '')}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getRabbitParentMarryDate(String stringDateTime) {
    if (stringDateTime.isNotEmpty) {
      var _a = DateTime.parse(stringDateTime);
      var _year = _a.year;
      var _month = CalendarData.month[_a.month - 1];
      var _day = _a.day;
      return '$_day $_month $_year';
    } else {
      return 'Belum disetel';
    }
  }
}
