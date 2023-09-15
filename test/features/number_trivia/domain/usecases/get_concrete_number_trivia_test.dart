import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../repositories/number_trivia_repository_test.dart';

void main() {
  late GetConcreteNumberTrivia usecase;
  late NumberTriviaRepository repository;

  setUp(() {
    repository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(repository);
  });

  // Testing data
  const int tNumber = 1;
  const String tText = 'test';
  const NumberTrivia tNumberTrivia = NumberTrivia(text: tText, number: tNumber);

  test(
    'should get trivia [NumberTrivia] for the number from the repository',
    () async {
      // arrange
      when(() => repository.getConcreteNumberTrivia(tNumber)).thenAnswer(
        (invocation) async => const Right(tNumberTrivia),
      );

      // act
      var result = await usecase(const ConcreteParams(number: tNumber));

      // assert
      expect(result, const Right(tNumberTrivia));
      verify(() => repository.getConcreteNumberTrivia(tNumber)).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
