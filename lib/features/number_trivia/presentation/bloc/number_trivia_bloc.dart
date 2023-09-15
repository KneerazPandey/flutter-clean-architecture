import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/error/failure.dart';
import 'package:flutter_clean_architecture/core/usecase/usecase.dart';
import 'package:flutter_clean_architecture/core/utils/input_converter.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/datasources/local_datasource/number_trivia_local_data_source_impl.dart';

import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String kServerFailureMessage = 'Server Failure';
const String lCachedFailureMessage = 'Cache Failure';
const String kInvalidInputFailureMessage =
    'Invalid Input - The number must be positive, integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required GetConcreteNumberTrivia concrete,
    required GetRandomNumberTrivia random,
    required InputConverter converter,
  })  : getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random,
        inputConverter = converter,
        super(InitialNumberTriviaState()) {
    on<GetTriviaForConcreteNumber>((
      GetTriviaForConcreteNumber event,
      Emitter<NumberTriviaState> emit,
    ) {
      emit(LoadingNumberTriviaState());
      final inputEither = inputConverter.stringToUnsignedInteger(event.number);
      inputEither.fold(
        (failure) => emit(
          const ErrorNumberTriviaState(message: kInvalidInputFailureMessage),
        ),
        (number) async {
          final concreteEither = await getConcreteNumberTrivia(
            ConcreteParams(number: number),
          );
          concreteEither.fold(
            (failure) => emit(
              ErrorNumberTriviaState(
                message: _mapFailureToMessage(failure),
              ),
            ),
            (trivia) => emit(LoadedNumberTriviaState(trivia: trivia)),
          );
        },
      );
    });

    on<GetTriviaForRandomNumber>((
      GetTriviaForRandomNumber event,
      Emitter<NumberTriviaState> emit,
    ) async {
      emit(LoadingNumberTriviaState());
      final triviaEither = await getRandomNumberTrivia(const NoParams());
      triviaEither.fold(
        (failure) => emit(ErrorNumberTriviaState(
          message: _mapFailureToMessage(failure),
        )),
        (trivia) => emit(LoadedNumberTriviaState(trivia: trivia)),
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return kServerFailureMessage;
      case CacheFailure:
        return kCachedNumberTrivia;
      case InvalidInputFailure:
        return kInvalidInputFailureMessage;
      default:
        return 'Unexpected error occured.';
    }
  }
}
