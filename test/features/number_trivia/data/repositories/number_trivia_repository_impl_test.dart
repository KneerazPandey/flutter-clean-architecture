import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/error/exception.dart';
import 'package:flutter_clean_architecture/core/error/failure.dart';
import 'package:flutter_clean_architecture/core/network/network_info.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/datasources/local_datasource/number_trivia_local_data_source.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/datasources/remote_datasource/number_trivia_remote_data_source.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../core/network/network_info_test.dart';
import '../datasources/local_datasource/number_trivia_local_data_source_test.dart';
import '../datasources/remote_datasource/number_trivia_remote_data_source_test.dart';

void main() {
  late NumberTriviaRepositoryImpl repositoryImpl;
  late NumberTriviaRemoteDataSource remoteDataSource;
  late NumberTriviaLocalDataSource localDataSource;
  late NetworkInfo networkInfo;

  setUp(() {
    remoteDataSource = MockNumberTriviaRemoteDataSource();
    localDataSource = MockNumberTriviaLocalDataSource();
    networkInfo = MockNetworkInfo();
    repositoryImpl = NumberTriviaRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
  });

  const int tNumber = 1;
  const String tText = 'test';
  const NumberTriviaModel tNumberTriviaModel = NumberTriviaModel(
    number: tNumber,
    text: tText,
  );
  const NumberTrivia tNumberTrivia = tNumberTriviaModel;

  group(
    'getConcreteNumberTrivia',
    () {
      setUp(() {
        when(() => remoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((invocation) async => tNumberTriviaModel);
        when(() => localDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((invocation) async {});
        when(() => localDataSource.getLastNumberTrivia())
            .thenAnswer((invocation) async => tNumberTriviaModel);
      });

      test(
        'should check if the device is online',
        () {
          // arrange
          when(() => networkInfo.isConnected)
              .thenAnswer((invocation) async => true);

          // act
          repositoryImpl.getConcreteNumberTrivia(tNumber);

          // assert
          verify(() => networkInfo.isConnected).called(1);
          verifyNoMoreInteractions(networkInfo);
        },
      );

      group(
        'device is online',
        () {
          setUp(() {
            when(() => networkInfo.isConnected)
                .thenAnswer((invocation) async => true);

            when(() => localDataSource.cacheNumberTrivia(tNumberTriviaModel))
                .thenAnswer((invocation) async {});
          });

          test(
            'shuould return remote data when the call to remote data source is successfull',
            () async {
              // arrange
              when(() => remoteDataSource.getConcreteNumberTrivia(tNumber))
                  .thenAnswer((invocation) async => tNumberTriviaModel);

              // act
              final result =
                  await repositoryImpl.getConcreteNumberTrivia(tNumber);

              // assert
              expect(result, const Right(tNumberTrivia));
              verify(() => remoteDataSource.getConcreteNumberTrivia(tNumber))
                  .called(1);
              verify(() => networkInfo.isConnected).called(1);
              verifyNoMoreInteractions(networkInfo);
              verifyNoMoreInteractions(remoteDataSource);
            },
          );

          test(
            'should cached the number trivial locally when the call to the remote data source is successfull',
            () async {
              // arrange
              when(() => remoteDataSource.getConcreteNumberTrivia(tNumber))
                  .thenAnswer(
                (invocation) async => tNumberTriviaModel,
              );

              // act
              final result =
                  await repositoryImpl.getConcreteNumberTrivia(tNumber);

              // assert
              expect(result, equals(const Right(tNumberTrivia)));
              verify(() => remoteDataSource.getConcreteNumberTrivia(tNumber))
                  .called(1);
              verify(() => networkInfo.isConnected).called(1);
              verify(() =>
                      localDataSource.cacheNumberTrivia(tNumberTriviaModel))
                  .called(1);
              verifyNoMoreInteractions(remoteDataSource);
              verifyNoMoreInteractions(localDataSource);
              verifyNoMoreInteractions(networkInfo);
            },
          );

          test(
            'should return [ServerFailure] when the call to remote data source is unsuccessfull',
            () async {
              // arrange
              when(() => remoteDataSource.getConcreteNumberTrivia(tNumber))
                  .thenThrow(ServerException());

              // act
              final result =
                  await repositoryImpl.getConcreteNumberTrivia(tNumber);

              // assert
              expect(result, equals(Left(ServerFailure())));
              verify(() => remoteDataSource.getConcreteNumberTrivia(tNumber))
                  .called(1);
              verifyNoMoreInteractions(remoteDataSource);
              verifyZeroInteractions(localDataSource);
            },
          );
        },
      );

      group(
        'device is offline',
        () {
          setUp(() {
            when(() => networkInfo.isConnected)
                .thenAnswer((invocation) async => false);
            when(() => localDataSource.cacheNumberTrivia(tNumberTriviaModel))
                .thenAnswer((invocation) async {});
            when(() => remoteDataSource.getRandomNumberTrivia())
                .thenAnswer((invocation) async => tNumberTriviaModel);
            when(() => localDataSource.getLastNumberTrivia())
                .thenAnswer((invocation) async => tNumberTriviaModel);
          });

          test(
            'should return a last locally cached data when the call to local data source is successfull and presented in the cache.',
            () async {
              // arrange
              when(() => localDataSource.getLastNumberTrivia())
                  .thenAnswer((invocation) async => tNumberTriviaModel);

              // act
              final result =
                  await repositoryImpl.getConcreteNumberTrivia(tNumber);

              // assert
              expect(result, equals(const Right(tNumberTrivia)));
              verify(() => localDataSource.getLastNumberTrivia()).called(1);
              verifyZeroInteractions(remoteDataSource);
            },
          );

          test(
            'should return [CacheFailure] when the call to local data source is unsuccessfull or if no cached data is presented',
            () async {
              // arrange
              when(() => localDataSource.getLastNumberTrivia())
                  .thenThrow(CacheException());

              // act
              final result =
                  await repositoryImpl.getConcreteNumberTrivia(tNumber);

              // assert
              expect(result, Left(CacheFailure()));
              verify(() => localDataSource.getLastNumberTrivia()).called(1);
              verifyNoMoreInteractions(localDataSource);
              verifyZeroInteractions(remoteDataSource);
            },
          );
        },
      );
    },
  );

  ///// For Random Number Trivia
  group(
    'getRandomNumberTrivia',
    () {
      setUp(() {
        when(() => localDataSource.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((invocation) async {});
        when(() => remoteDataSource.getRandomNumberTrivia())
            .thenAnswer((invocation) async => tNumberTriviaModel);
        when(() => localDataSource.getLastNumberTrivia())
            .thenAnswer((invocation) async => tNumberTriviaModel);
      });

      test(
        'should check if the device is online',
        () {
          // arrange
          when(() => networkInfo.isConnected)
              .thenAnswer((invocation) async => true);

          // act
          repositoryImpl.getRandomNumberTrivia();

          // assert
          verify(() => networkInfo.isConnected).called(1);
          verifyNoMoreInteractions(networkInfo);
        },
      );

      group(
        'device is online',
        () {
          setUp(() {
            when(() => networkInfo.isConnected)
                .thenAnswer((invocation) async => true);

            when(() => localDataSource.cacheNumberTrivia(tNumberTriviaModel))
                .thenAnswer((invocation) async {});
          });

          test(
            'shuould return remote data when the call to remote data source is successfull',
            () async {
              // arrange
              when(() => remoteDataSource.getRandomNumberTrivia())
                  .thenAnswer((invocation) async => tNumberTriviaModel);

              // act
              final result = await repositoryImpl.getRandomNumberTrivia();

              // assert
              expect(result, const Right(tNumberTrivia));
              verify(() => remoteDataSource.getRandomNumberTrivia()).called(1);
              verify(() => networkInfo.isConnected).called(1);
              verifyNoMoreInteractions(networkInfo);
              verifyNoMoreInteractions(remoteDataSource);
            },
          );

          test(
            'should cached the number trivial locally when the call to the remote data source is successfull',
            () async {
              // arrange
              when(() => remoteDataSource.getRandomNumberTrivia()).thenAnswer(
                (invocation) async => tNumberTriviaModel,
              );

              // act
              final result = await repositoryImpl.getRandomNumberTrivia();

              // assert
              expect(result, equals(const Right(tNumberTrivia)));
              verify(() => remoteDataSource.getRandomNumberTrivia()).called(1);
              verify(() => networkInfo.isConnected).called(1);
              verify(() =>
                      localDataSource.cacheNumberTrivia(tNumberTriviaModel))
                  .called(1);
              verifyNoMoreInteractions(remoteDataSource);
              verifyNoMoreInteractions(localDataSource);
              verifyNoMoreInteractions(networkInfo);
            },
          );

          test(
            'should return [ServerFailure] when the call to remote data source is unsuccessfull',
            () async {
              // arrange
              when(() => remoteDataSource.getRandomNumberTrivia())
                  .thenThrow(ServerException());

              // act
              final result = await repositoryImpl.getRandomNumberTrivia();

              // assert
              expect(result, equals(Left(ServerFailure())));
              verify(() => remoteDataSource.getRandomNumberTrivia()).called(1);
              verifyNoMoreInteractions(remoteDataSource);
              verifyZeroInteractions(localDataSource);
            },
          );
        },
      );

      group(
        'device is offline',
        () {
          setUp(() {
            when(() => networkInfo.isConnected)
                .thenAnswer((invocation) async => false);
            when(() => localDataSource.cacheNumberTrivia(tNumberTriviaModel))
                .thenAnswer((invocation) async {});
            when(() => remoteDataSource.getRandomNumberTrivia())
                .thenAnswer((invocation) async => tNumberTriviaModel);
            when(() => localDataSource.getLastNumberTrivia())
                .thenAnswer((invocation) async => tNumberTriviaModel);
          });

          test(
            'should return a last locally cached data when the call to local data source is successfull and presented in the cache.',
            () async {
              // arrange
              when(() => localDataSource.getLastNumberTrivia())
                  .thenAnswer((invocation) async => tNumberTriviaModel);

              // act
              final result = await repositoryImpl.getRandomNumberTrivia();

              // assert
              expect(result, equals(const Right(tNumberTrivia)));
              verify(() => localDataSource.getLastNumberTrivia()).called(1);
              verifyZeroInteractions(remoteDataSource);
            },
          );

          test(
            'should return [CacheFailure] when the call to local data source is unsuccessfull or if no cached data is presented',
            () async {
              // arrange
              when(() => localDataSource.getLastNumberTrivia())
                  .thenThrow(CacheException());

              // act
              final result = await repositoryImpl.getRandomNumberTrivia();

              // assert
              expect(result, Left(CacheFailure()));
              verify(() => localDataSource.getLastNumberTrivia()).called(1);
              verifyNoMoreInteractions(localDataSource);
              verifyZeroInteractions(remoteDataSource);
            },
          );
        },
      );
    },
  );
}
