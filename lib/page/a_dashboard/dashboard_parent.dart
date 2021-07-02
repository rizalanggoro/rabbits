import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rabbits/bloc/a_parent/a_parent_bloc.dart';
import 'package:rabbits/data/a_static.dart';
import 'package:rabbits/model/a_parent_model.dart';
import 'package:rabbits/page/a_parent_detail.dart';
import 'package:rabbits/util/util.dart';
import 'package:rabbits/view/a_card.dart';

// ignore: use_key_in_widget_constructors
class DashboardParent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<DashboardParent> {
  @override
  Widget build(BuildContext context) {
    _init();

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<AParentBloc>()),
      ],
      child: _body,
    );
  }

  Util? _util;
  _init() {
    _util ??= Util()..init(context);
  }

  get _body => BlocBuilder<AParentBloc, AParentState>(
        builder: (context, state) {
          if (state is AParentOnAdd) {
            var _parentModel = state.aParentModel;
            AStatic.listParentKey.add(_parentModel.parentKey!);
            AStatic.listParentModel.add(_parentModel);

            context.read<AParentBloc>().add(AParentResetToInitial());
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _card1(),
                _card2(),
              ],
            ),
          );
        },
      );

  _card1() => ACard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, bottom: 8),
              child: Text(
                'Mengandung',
                style: TextStyle(
                  fontSize: _util!.textTheme.bodyText1!.fontSize,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            ListView.builder(
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    _listItemParent(
                      index,
                      parentModel: AStatic.listPregnantParentModel[index],
                    ),
                    if (index != AStatic.listPregnantParentKey.length - 1)
                      const Divider(),
                  ],
                );
              },
              itemCount: AStatic.listPregnantParentKey.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),
          ],
        ),
        padding: const EdgeInsets.only(bottom: 8),
      );

  _card2() => ACard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, bottom: 8),
            child: Text(
              'Tidak mengandung',
              style: TextStyle(
                fontSize: _util!.textTheme.bodyText1!.fontSize,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          ListView.builder(
            itemBuilder: (context, index) {
              return Column(
                children: [
                  _listItemParent(
                    index,
                    parentModel: AStatic.listParentModel[index],
                  ),
                  if (index != AStatic.listParentKey.length - 1)
                    const Divider(),
                ],
              );
            },
            itemCount: AStatic.listParentKey.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ],
      ),
      padding: const EdgeInsets.only(bottom: 8),
      margin: const EdgeInsets.only(top: 16, bottom: 16));

  _listItemParent(index, {required AParentModel parentModel}) => ListTile(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AParentDetail(
                parentModel: parentModel,
              ),
            )),
        trailing: const Icon(Icons.chevron_right_rounded),
        title: Text(parentModel.parentName ?? ''),
        subtitle: Text(
          'Tanggal kawin : ${_util!.parseDate(parentModel.parentMarryDate)}',
        ),
      );
}
