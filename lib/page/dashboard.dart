import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rabbits/bloc/rabbit_child/rabbit_child_bloc.dart';
import 'package:rabbits/bloc/rabbit_child/rabbit_child_event.dart';
import 'package:rabbits/bloc/rabbit_parent/rabbit_parent_bloc.dart';
import 'package:rabbits/bloc/rabbit_parent/rabbit_parent_event.dart';
import 'package:rabbits/bloc/setting/setting_bloc.dart';
import 'package:rabbits/bloc/setting/setting_event.dart';
import 'package:rabbits/bloc/setting/setting_state.dart';
import 'package:rabbits/data/static_data.dart';
import 'package:rabbits/page/rabbits_child.dart';
import 'package:rabbits/page/rabbits_parent.dart';
import 'package:rabbits/page/setting.dart';

// ignore: use_key_in_widget_constructors
class Dashboard extends StatefulWidget {
  static var tag = 'dashboard-page';

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    _init();

    return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<RabbitChildBloc>()),
          BlocProvider.value(value: context.read<RabbitParentBloc>()),
          BlocProvider.value(value: context.read<SettingBloc>()),
        ],
        child: Scaffold(
          backgroundColor: Colors.white,
          body: _body,
          appBar: AppBar(
            title: const Text('Rabbits'),
          ),
        ));
  }

  _init() {
    print('dashboard init called');

    //? get all setting
    context.read<SettingBloc>().add(GetAllSetting());
  }

  final _listDashboard = [
    {
      'title': 'Indukan',
      'subtitle': 'Kelola indukan kelinci',
      'route': RabbitsParent.tag,
    },
    {
      'title': 'Anakan',
      'subtitle': 'Kelola anakan kelinci',
      'route': RabbitsChild.tag,
    },
    {
      'title': 'Setelan',
      'subtitle': 'Kelola harga kelinci dan harga pakan',
      'route': Setting.tag,
    },
  ];

  Map<String, dynamic>? _mapSetting;
  get _body => BlocBuilder<SettingBloc, SettingState>(
        builder: (context, state) {
          if (state is OnGetAllSettingCompleted) {
            _mapSetting = state.map;

            //? initialize static data
            StaticData.unitFood = int.parse(_mapSetting![SettingBloc.keys[0]]);
            StaticData.unitWeight =
                int.parse(_mapSetting![SettingBloc.keys[1]]);
            StaticData.foodPrice = int.parse(_mapSetting![SettingBloc.keys[2]]);
            StaticData.petPrice = int.parse(_mapSetting![SettingBloc.keys[3]]);
            StaticData.foodWeight =
                double.parse(_mapSetting![SettingBloc.keys[4]]);
            StaticData.estimateBorn =
                _mapSetting![SettingBloc.rabbitParentEstimateBornKey];
            StaticData.addBox = _mapSetting![SettingBloc.rabbitParentAddBoxKey];
          }

          if (_mapSetting != null) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    itemBuilder: (context, index) {
                      var _isLast = index == _listDashboard.length - 1;
                      var _route = _listDashboard[index]['route'];
                      return Column(
                        children: [
                          ListTile(
                            title: Text(_listDashboard[index]['title']!),
                            subtitle: Text(_listDashboard[index]['subtitle']!),
                            onTap: () => Navigator.pushNamed(context, _route!),
                          ),
                          if (!_isLast) const Divider(),
                        ],
                      );
                    },
                    itemCount: _listDashboard.length,
                    shrinkWrap: true,
                  ),
                  if (kDebugMode)
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<RabbitChildBloc>()
                                      .add(DeleteAllDatabase());
                                },
                                child: const Text('Hapus semua database')),
                            ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<RabbitParentBloc>()
                                      .add(DeleteDatabaseRabbitParent());
                                },
                                child:
                                    const Text('Hapus rabbit parent database')),
                          ],
                        )),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Loading'));
          }
        },
      );
}
