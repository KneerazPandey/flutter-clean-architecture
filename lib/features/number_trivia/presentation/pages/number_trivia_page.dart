import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/number_trivia_bloc.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Number Trivia'),
          centerTitle: true,
        ),
        body: buildBody(context),
      ),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              // Top Half
              const SizedBox(height: 10),
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (BuildContext context, NumberTriviaState state) {
                  if (state is InitialNumberTriviaState) {
                    return const MessageDisplay(message: 'Start Searching');
                  } else if (state is LoadingNumberTriviaState) {
                    return const LoadingWidget();
                  } else if (state is LoadedNumberTriviaState) {
                    return TriviaDisplay(numberTrivia: state.trivia);
                  } else if (state is ErrorNumberTriviaState) {
                    return MessageDisplay(message: state.message);
                  }
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                    child: const Placeholder(),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Second Half
              const TriviaControls(),
            ],
          ),
        ),
      ),
    );
  }
}
