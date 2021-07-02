import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rabbits/bloc/a_child/a_child_bloc.dart';
import 'package:rabbits/bloc/a_parent/a_parent_bloc.dart';
import 'package:rabbits/bloc/a_setting/a_setting_bloc.dart';
import 'package:rabbits/bloc/food/food_bloc.dart';
import 'package:rabbits/data/a_static.dart';
import 'package:rabbits/page/a_dashboard.dart';
import 'package:rabbits/util/util.dart';

// ignore: use_key_in_widget_constructors
class ASplash extends StatefulWidget {
  static var tag = 'a-splash-page';
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ASplash> {
  @override
  Widget build(BuildContext context) {
    _initializeData();

    Util util = Util()..init(context);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.pets_rounded,
              color: Colors.white,
              size: util.textTheme.headline5!.fontSize,
            ),
            Container(height: 8),
            Text(
              'Rabbits',
              style: TextStyle(
                color: Colors.white,
                fontSize: util.textTheme.headline5!.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _initializeData() async {
    // get all setting
    var _mapSetting = await ASettingBloc().getAll();
    AStatic.parentEstimateBorn =
        _mapSetting[ASettingBloc.parentEstimateBornKey];
    AStatic.parentAddBox = _mapSetting[ASettingBloc.parentAddBoxKey];
    AStatic.childSellUnit = _mapSetting[ASettingBloc.childSellUnitKey];
    AStatic.childSellPrice = _mapSetting[ASettingBloc.childSellPriceKey];

    // get all food
    var _mapFoodList = await FoodBloc().getAll();
    AStatic.listFoodKey = _mapFoodList['key'];
    AStatic.listFoodModel = _mapFoodList['model'];

    // get all parent
    var _mapParent = await AParentBloc().getAll();
    AStatic.listParentKey = _mapParent[AParentBloc.listParentKeyKey];
    AStatic.listParentModel = _mapParent[AParentBloc.listParentModelKey];
    AStatic.listPregnantParentKey =
        _mapParent[AParentBloc.listPregnantParentKeyKey];
    AStatic.listPregnantParentModel =
        _mapParent[AParentBloc.listPregnantParentModelKey];

    // get all child
    var _mapChild = await AChildBloc().getAll();
    AStatic.listChildKey = _mapChild[AChildBloc.listChildKeyKey];
    AStatic.listChildModel = _mapChild[AChildBloc.listChildModelKey];

    Navigator.pushReplacementNamed(context, ADashboard.tag);
  }
}
