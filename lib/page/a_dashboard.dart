import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rabbits/bloc/a_child/a_child_bloc.dart';
import 'package:rabbits/bloc/a_parent/a_parent_bloc.dart';
import 'package:rabbits/bloc/a_setting/a_setting_bloc.dart';
import 'package:rabbits/bloc/navigation/navigation_bloc.dart';
import 'package:rabbits/model/a_child_model.dart';
import 'package:rabbits/model/a_parent_model.dart';
import 'package:rabbits/page/a_dashboard/dashboard_child.dart';
import 'package:rabbits/page/a_dashboard/dashboard_parent.dart';
import 'package:rabbits/page/a_dashboard/a_dashboard_setting.dart';
import 'package:rabbits/util/util.dart';
import 'package:rabbits/view/dialog/a_dialog_text_field.dart';

// ignore: use_key_in_widget_constructors
class ADashboard extends StatefulWidget {
  static var tag = 'dashboard-redesign-page';
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ADashboard> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    _init();

    return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<NavigationBloc>()),
          BlocProvider.value(value: context.read<ASettingBloc>()),
          BlocProvider.value(value: context.read<AParentBloc>()),
          BlocProvider.value(value: context.read<AChildBloc>()),
        ],
        child: BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
            if (state is OnChangeNavigation) {
              _currentIndex = state.index;
            }

            return Scaffold(
              floatingActionButton: _currentIndex != 2
                  ? FloatingActionButton.extended(
                      onPressed: () => _onPressedFab(),
                      icon: const Icon(Icons.add_rounded),
                      label: Text(
                        _currentIndex == 0 ? 'Tambah indukan' : 'Tambah anakan',
                      ),
                    )
                  : null,
              appBar: AppBar(
                title: const Text('Rabbits'),
              ),
              bottomNavigationBar: _bottomAppBar,
              body: _body,
            );
          },
        ));
  }

  _onPressedFab() {
    switch (_currentIndex) {
      case 0:
        // show dialog add rabbit parent
        showDialog(
          context: context,
          builder: (context) => ADialogTextField(
            title: 'Tambah indukan',
            hintText: 'Masukkan nama indukan',
            textInputType: TextInputType.name,
            onClickOk: (text) {
              var _parentModel = AParentModel(
                parentKey: _util!.generateKey,
                parentMarryDate: '',
                parentName: text,
                parentStatus: '',
              );
              context
                  .read<AParentBloc>()
                  .add(AParentAdd(aParentModel: _parentModel));
            },
          ),
        );
        break;

      case 1:
        // show dialog add rabbit child
        showDialog(
          context: context,
          builder: (context) => ADialogTextField(
            title: 'Tambah anakan',
            hintText: 'Masukkan nama anakan',
            textInputType: TextInputType.name,
            onClickOk: (text) {
              var _model = AChildModel(
                childKey: _util!.generateKey,
                childName: text,
                childBornDate: DateTime.now().toString(),
                childWeight: '0',
                childFoodMap: '{}',
              );
              context.read<AChildBloc>().add(AChildAdd(childModel: _model));
            },
          ),
        );
        break;
    }
  }

  get _bottomAppBar => Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 8,
          ),
        ],
      ),
      child: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        selectedLabelStyle: TextStyle(
          fontSize: _util!.textTheme.caption!.fontSize,
        ),
        onTap: (index) {
          // change navigation using navigation bloc
          context.read<NavigationBloc>().add(ChangeNavigation(index: index));
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.pets_rounded),
            label: 'Indukan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_rounded),
            label: 'Anakan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Setelan',
          ),
        ],
      ));

  get _body => _currentIndex == 0
      ? DashboardParent()
      : _currentIndex == 1
          ? DashboardChild()
          : ADashboardSetting();

  Util? _util;
  _init() {
    print('a dashboard -> _init called');
    _util ??= Util()..init(context);
  }
}
