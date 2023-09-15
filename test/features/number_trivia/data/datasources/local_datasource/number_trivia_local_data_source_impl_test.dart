import 'package:flutter_clean_architecture/core/error/exception.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/datasources/local_datasource/number_trivia_local_data_source_impl.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../fixtures/fixture_reader.dart';

class MockSharedPreference extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSourceImpl localDataSourceImpl;
  late MockSharedPreference mockSharedPreference;

  setUp(() {
    mockSharedPreference = MockSharedPreference();
    localDataSourceImpl = NumberTriviaLocalDataSourceImpl(
      preferences: mockSharedPreference,
    );
  });

  final NumberTriviaModel tNumberTriviaModel = NumberTriviaModel.fromJson(
    fixtureReader('trivia_cached.json'),
  );

  group(
    'getLastNumberTrivia',
    () {
      test(
        'should return [NumberTriviaModel] from shared preference when there is one in the cache',
        () async {
          // arrange
          when(() => mockSharedPreference.getString(kCachedNumberTrivia))
              .thenReturn(
            fixtureReader('trivia_cached.json'),
          );

          // act
          final result = await localDataSourceImpl.getLastNumberTrivia();

          // assert
          verify(() => mockSharedPreference.getString(kCachedNumberTrivia))
              .called(1);
          expect(result, tNumberTriviaModel);
        },
      );

      test(
        'should return [CacheFailure] when the call to local data source getLastNumberTrivia when there is no any cache',
        () async {
          // arrange
          when(() => mockSharedPreference.getString(kCachedNumberTrivia))
              .thenThrow(CacheException());

          // act
          final call = localDataSourceImpl.getLastNumberTrivia;

          // assert
          expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
          verify(() => mockSharedPreference.getString(kCachedNumberTrivia))
              .called(1);
          verifyNoMoreInteractions(mockSharedPreference);
        },
      );
    },
  );

  group(
    'cacheNumberTrivia',
    () {
      test(
        'should cached freshly obtained NumberTrivia using shared preference',
        () async {
          // arrange
          when(
            () => mockSharedPreference.setString(
                kCachedNumberTrivia, tNumberTriviaModel.toJson()),
          ).thenAnswer((Invocation realInvocation) async => true);

          // act
          await localDataSourceImpl.cacheNumberTrivia(tNumberTriviaModel);

          // assert
          verify(
            () => mockSharedPreference.setString(
                kCachedNumberTrivia, tNumberTriviaModel.toJson()),
          );
          verifyNoMoreInteractions(mockSharedPreference);
        },
      );
    },
  );
}
