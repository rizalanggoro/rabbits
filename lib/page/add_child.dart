import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rabbits/bloc/rabbit_child/rabbit_child_bloc.dart';
import 'package:rabbits/bloc/rabbit_child/rabbit_child_event.dart';
import 'package:rabbits/bloc/rabbit_child/rabbit_child_state.dart';
import 'package:rabbits/model/rabbit_child_model.dart';
import 'package:rabbits/util/util.dart';

// ignore: use_key_in_widget_constructors
class AddChild extends StatefulWidget {
  static var tag = 'add-child-page';
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AddChild> {
  @override
  Widget build(BuildContext context) {
    _init();

    return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<RabbitChildBloc>()),
        ],
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Tambah kandang'),
          ),
          body: _body,
        ));
  }

  Util? _util;
  _init() {
    _util ??= Util()..init(context);
  }

  final TextEditingController _textEditingControllerName =
      TextEditingController();
  get _body => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: TextField(
                controller: _textEditingControllerName,
                decoration: const InputDecoration(hintText: 'Nama kandang'),
              ),
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16),
              child: BlocBuilder<RabbitChildBloc, RabbitChildState>(
                builder: (context, state) {
                  if (state is OnAdd) {
                    //? reset to initial state
                    context.read<RabbitChildBloc>().add(ResetToInitial());

                    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                      //? pop back
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    });
                  }

                  return ElevatedButton(
                    onPressed: () {
                      var _key = _util!.generateKey;
                      var _name = _textEditingControllerName.text;
                      if (_name.isNotEmpty) {
                        var _rabbitChildModel = RabbitChildModel(
                          key: _key,
                          homeName: _name,
                          foodCount: '0',
                          petBorn: DateTime.now().toString(),
                          petWeight: '0',
                        );
                        context
                            .read<RabbitChildBloc>()
                            .add(Add(rabbitChildModel: _rabbitChildModel));
                      }
                    },
                    child: const Text('Tambah'),
                  );
                },
              ),
            ),
          ],
        ),
      );
}
