part of 'number_trivia_bloc.dart';

sealed class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();

  @override
  List<Object> get props => [];
}

final class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String number;

  const GetTriviaForConcreteNumber(this.number);

  @override
  List<Object> get props => [number];
}

final class GetTriviaForRandomNumber extends NumberTriviaEvent {}
