import 'dart:convert';

import 'package:flutter_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const int tNumber = 1;
  const String tText = 'Test Text';
  const NumberTriviaModel tNumberTriviaModel = NumberTriviaModel(
    number: tNumber,
    text: tText,
  );

  setUp(() {});

  test(
    'should be a sub class of [NumberTrivia] entity',
    () {
      // assert
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group(
    'fromMap',
    () {
      test(
        'should return a valid model when the JSON number is an integer',
        () {
          // arrange
          final Map<String, dynamic> jsonMap =
              jsonDecode(fixtureReader('trivia.json'));

          // act
          final result = NumberTriviaModel.fromMap(jsonMap);

          // assert
          expect(result, tNumberTriviaModel);
        },
      );

      test(
        'should return a valid model when the JSON number is double',
        () {
          // arrange
          final Map<String, dynamic> jsonMap = jsonDecode(
            fixtureReader('trivia_double.json'),
          );

          // act
          final result = NumberTriviaModel.fromMap(jsonMap);

          // assert
          expect(result, tNumberTriviaModel);
        },
      );
    },
  );

  group(
    'toMap',
    () {
      test(
        'should return a JSON map containing the proper data',
        () {
          // arrange
          Map<String, dynamic> jsonMap = {
            'number': tNumber,
            'text': tText,
          };

          // act
          NumberTriviaModel numberTriviaModel =
              NumberTriviaModel.fromMap(jsonMap);
          final result = numberTriviaModel.toMap();

          // assert
          expect(result, jsonMap);
        },
      );
    },
  );
}
