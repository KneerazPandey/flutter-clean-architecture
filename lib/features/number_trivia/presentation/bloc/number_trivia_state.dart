part of 'number_trivia_bloc.dart';

sealed class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

final class InitialNumberTriviaState extends NumberTriviaState {}

final class LoadingNumberTriviaState extends NumberTriviaState {}

final class LoadedNumberTriviaState extends NumberTriviaState {
  final NumberTrivia trivia;

  const LoadedNumberTriviaState({
    required this.trivia,
  });

  @override
  List<Object> get props => [trivia];
}

final class ErrorNumberTriviaState extends NumberTriviaState {
  final String message;

  const ErrorNumberTriviaState({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
