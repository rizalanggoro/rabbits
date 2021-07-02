import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rabbits/bloc/a_child/a_child_bloc.dart';
import 'package:rabbits/data/a_static.dart';
import 'package:rabbits/model/a_child_model.dart';
import 'package:rabbits/page/a_child_detail.dart';
import 'package:rabbits/view/a_card.dart';

// ignore: use_key_in_widget_constructors
class DashboardChild extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<DashboardChild> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<AChildBloc>()),
      ],
      child: _body,
    );
  }

  get _body => BlocBuilder<AChildBloc, AChildState>(
        builder: (context, state) {
          if (state is AChildOnAdd) {
            var _model = state.childModel;
            AStatic.listChildKey.add(_model.childKey!);
            AStatic.listChildModel.add(_model);
            context.read<AChildBloc>().add(AChildResetInitial());
          }

          if (AStatic.listChildKey.isNotEmpty) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  _card1(),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Tidak ada data'));
          }
        },
      );

  _card1() => ACard(
        padding: const EdgeInsets.symmetric(vertical: 8),
        margin: const EdgeInsets.only(bottom: 16),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Column(
              children: [
                _listTileChild(
                  index,
                  AStatic.listChildModel[index],
                ),
                if (index != AStatic.listChildKey.length - 1) const Divider(),
              ],
            );
          },
          itemCount: AStatic.listChildKey.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
      );

  _listTileChild(index, AChildModel model) => ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AChildDetail(
                        index: index,
                      )));
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(model.childName!),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(height: 4),
            Text(
              'Lama pemeliharaan : ${_parsePassedDay(model.childBornDate!)} hari\n'
              'Berat anakan : ${model.childWeight} kg\n'
              'Perkiraan harga : Rp 100.000',
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
      );

  String _parsePassedDay(String bornDate) {
    var _a = DateTime.parse(bornDate);
    var _b = DateTime.now();
    var _c = _b.difference(_a).inDays;
    return '$_c';
  }
}
