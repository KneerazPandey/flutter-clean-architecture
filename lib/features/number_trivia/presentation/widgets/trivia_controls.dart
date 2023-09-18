import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    super.key,
  });

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  late TextEditingController inputConroller;

  @override
  void initState() {
    super.initState();
    inputConroller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    inputConroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          TextField(
            keyboardType: TextInputType.number,
            controller: inputConroller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Input a number",
            ),
            onSubmitted: (String value) {
              dispatchConcrete();
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: dispatchConcrete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: const Text('Search'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: dispatchRandom,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Get random trivia'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void dispatchConcrete() {
    BlocProvider.of<NumberTriviaBloc>(context).add(
      GetTriviaForConcreteNumber(inputConroller.text),
    );
    inputConroller.clear();
  }

  void dispatchRandom() {
    BlocProvider.of<NumberTriviaBloc>(context).add(
      GetTriviaForRandomNumber(),
    );
    inputConroller.clear();
  }
}
