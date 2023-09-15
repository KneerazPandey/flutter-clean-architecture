import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/error/failure.dart';
import 'package:flutter_clean_architecture/core/utils/input_converter.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      converter: mockInputConverter,
    );
  });

  test(
    'initial state should be InitialNumberTriviaState',
    () {
      // assert
      expect(bloc.state, equals(InitialNumberTriviaState()));
    },
  );

  group(
    'getTriviaForConcreteNumber',
    () {
      const String tNumber = '1';
      const int tNumberParse = 1;
      const NumberTrivia tNumberTrivia = NumberTrivia(
        text: 'test',
        number: tNumberParse,
      );

      test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
          // arrange
          when(() => mockInputConverter.stringToUnsignedInteger(tNumber))
              .thenReturn(const Right(tNumberParse));

          // act
          bloc.add(const GetTriviaForConcreteNumber(tNumber));
          await untilCalled(
            () => mockInputConverter.stringToUnsignedInteger(tNumber),
          );

          // assert
          verify(() => mockInputConverter.stringToUnsignedInteger(tNumber))
              .called(1);
        },
      );

      test(
        'should emit [ErrorNumberTriviaState] when the input is invalid',
        () {
          // arrange
          when(() => mockInputConverter.stringToUnsignedInteger(tNumber))
              .thenReturn(
            Left(InvalidInputFailure()),
          );

          // act
          bloc.add(const GetTriviaForConcreteNumber(tNumber));

          // act
          expectLater(
            bloc.state,
            emitsInOrder(
              [
                InitialNumberTriviaState(),
                const ErrorNumberTriviaState(
                    message: kInvalidInputFailureMessage)
              ],
            ),
          );
        },
      );
    },
  );
}
