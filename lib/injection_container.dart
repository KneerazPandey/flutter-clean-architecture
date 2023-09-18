import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'core/network/network_info_impl.dart';
import 'core/utils/input_converter.dart';
import 'features/number_trivia/data/datasources/local_datasource/number_trivia_local_data_source.dart';
import 'features/number_trivia/data/datasources/local_datasource/number_trivia_local_data_source_impl.dart';
import 'features/number_trivia/data/datasources/remote_datasource/number_trivia_remote_data_source.dart';
import 'features/number_trivia/data/datasources/remote_datasource/number_trivia_remote_data_source_impl.dart';
import 'features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

final sl = GetIt.instance;
Future<void> init() async {
  //! Features - Number Trivia
  // Bloc
  sl.registerFactory<NumberTriviaBloc>(
    () => NumberTriviaBloc(
      concrete: sl(),
      random: sl(),
      converter: sl(),
    ),
  );

  // Usecases
  sl.registerLazySingleton<GetConcreteNumberTrivia>(
    () => GetConcreteNumberTrivia(sl()),
  );

  sl.registerLazySingleton<GetRandomNumberTrivia>(
    () => GetRandomNumberTrivia(sl()),
  );

  // Repository
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Datasource
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(preferences: sl()),
  );

  //! Core
  sl.registerLazySingleton<InputConverter>(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
}
