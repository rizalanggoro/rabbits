import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rabbits/bloc/a_child/a_child_bloc.dart';
import 'package:rabbits/bloc/a_parent/a_parent_bloc.dart';
import 'package:rabbits/bloc/a_parent_history/a_parent_history_bloc.dart';
import 'package:rabbits/bloc/a_setting/a_setting_bloc.dart';
import 'package:rabbits/bloc/food/food_bloc.dart';
import 'package:rabbits/bloc/navigation/navigation_bloc.dart';
import 'package:rabbits/bloc/rabbit_child/rabbit_child_bloc.dart';
import 'package:rabbits/bloc/rabbit_parent/rabbit_parent_bloc.dart';
import 'package:rabbits/bloc/rabbit_parent_add_history/rabbit_parent_add_history_bloc.dart';
import 'package:rabbits/bloc/setting/setting_bloc.dart';
import 'package:rabbits/page/a_add_parent_history.dart';
import 'package:rabbits/page/a_child_detail.dart';
import 'package:rabbits/page/a_parent_detail.dart';
import 'package:rabbits/page/a_splash.dart';
import 'package:rabbits/page/add_child.dart';
import 'package:rabbits/page/add_food.dart';
import 'package:rabbits/page/add_rabbit_parent_history.dart';
import 'package:rabbits/page/child_detail.dart';
import 'package:rabbits/page/dashboard.dart';
import 'package:rabbits/page/a_dashboard.dart';
import 'package:rabbits/page/parent_detail.dart';
import 'package:rabbits/page/rabbits_child.dart';
import 'package:rabbits/page/rabbits_parent.dart';
import 'package:rabbits/page/setting.dart';

// ignore: use_key_in_widget_constructors
class RabbitsApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (c) => RabbitChildBloc()),
          BlocProvider(create: (c) => SettingBloc()),
          BlocProvider(create: (c) => RabbitParentBloc()),
          BlocProvider(create: (c) => RabbitParentAddHistoryBloc()),

          // a-bloc
          BlocProvider(create: (c) => NavigationBloc()),
          BlocProvider(create: (c) => FoodBloc()),
          BlocProvider(create: (c) => ASettingBloc()),
          BlocProvider(create: (c) => AParentBloc()),
          BlocProvider(create: (c) => AChildBloc()),
          BlocProvider(create: (c) => AParentHistoryBloc()),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('id', 'ID'),
          ],
          debugShowCheckedModeBanner: false,
          theme: ThemeData(),
          routes: {
            Dashboard.tag: (c) => Dashboard(),
            RabbitsParent.tag: (c) => RabbitsParent(),
            RabbitsChild.tag: (c) => RabbitsChild(),
            Setting.tag: (c) => Setting(),
            ChildDetail.tag: (c) => const ChildDetail(),
            AddChild.tag: (c) => AddChild(),
            ParentDetail.tag: (c) => const ParentDetail(),
            AddRabbitParentHistory.tag: (c) => const AddRabbitParentHistory(),

            // a-page
            ASplash.tag: (c) => ASplash(),
            ADashboard.tag: (c) => ADashboard(),
            AddFood.tag: (c) => const AddFood(),
            AParentDetail.tag: (c) => const AParentDetail(),
            AChildDetail.tag: (c) => const AChildDetail(),
            AAddParentHistory.tag: (c) => const AAddParentHistory(),
          },
          initialRoute: ASplash.tag,
        ));
  }
}
