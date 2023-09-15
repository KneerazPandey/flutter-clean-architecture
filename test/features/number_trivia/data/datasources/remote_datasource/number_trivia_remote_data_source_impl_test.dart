import 'package:flutter_clean_architecture/core/error/exception.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/datasources/remote_datasource/number_trivia_remote_data_source_impl.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

import '../../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late NumberTriviaRemoteDataSourceImpl remoteDataSourceImpl;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    remoteDataSourceImpl = NumberTriviaRemoteDataSourceImpl(
      client: mockHttpClient,
    );
  });

  const int tNumber = 1;
  final NumberTriviaModel tNumberTriviaModel = NumberTriviaModel.fromJson(
    fixtureReader('trivia.json'),
  );

  group(
    'getConcreteNumberTrivia',
    () {
      test(
        'should preform a GET request on a URL with the number being the endpoint and header with application/json',
        () {
          // arrange
          Uri uri = Uri.parse('http://numbersapi.com/$tNumber');
          when(
            () => mockHttpClient.get(
              uri,
              headers: <String, String>{
                'Content-Type': 'application/json',
              },
            ),
          ).thenAnswer(
            (invocation) async =>
                http.Response(fixtureReader('trivia.json'), 200),
          );

          // act
          remoteDataSourceImpl.getConcreteNumberTrivia(tNumber);

          // assert
          verify(
            () => mockHttpClient.get(
              uri,
              headers: <String, String>{
                'Content-Type': 'application/json',
              },
            ),
          ).called(1);
          verifyNoMoreInteractions(mockHttpClient);
        },
      );

      test(
        'should return NumberTriviaModel when the response status code is 200',
        () async {
          // arrange
          Uri uri = Uri.parse('http://numbersapi.com/$tNumber');
          when(
            () => mockHttpClient.get(
              uri,
              headers: <String, String>{
                'Content-Type': 'application/json',
              },
            ),
          ).thenAnswer(
            (invocation) async =>
                http.Response(fixtureReader('trivia.json'), 200),
          );

          // act
          final result =
              await remoteDataSourceImpl.getConcreteNumberTrivia(tNumber);

          // assert
          expect(result, tNumberTriviaModel);
          verify(
            () => mockHttpClient.get(
              uri,
              headers: <String, String>{
                'Content-Type': 'application/json',
              },
            ),
          ).called(1);
          verifyNoMoreInteractions(mockHttpClient);
        },
      );

      test(
        'should return ServerException when the response status code is not 200',
        () async {
          // arrange
          Uri uri = Uri.parse('http://numbersapi.com/$tNumber');
          when(
            () => mockHttpClient.get(
              uri,
              headers: <String, String>{
                'Content-Type': 'application/json',
              },
            ),
          ).thenAnswer(
            (invocation) async => http.Response("Something went wrong", 404),
          );

          // act
          final call = remoteDataSourceImpl.getConcreteNumberTrivia;

          // assert
          expect(
            () => call(tNumber),
            throwsA(const TypeMatcher<ServerException>()),
          );
          verify(
            () => mockHttpClient.get(
              uri,
              headers: <String, String>{
                'Content-Type': 'application/json',
              },
            ),
          ).called(1);
          verifyNoMoreInteractions(mockHttpClient);
        },
      );
    },
  );

  group(
    'getRandomNumberTrivia',
    () {},
  );
}
