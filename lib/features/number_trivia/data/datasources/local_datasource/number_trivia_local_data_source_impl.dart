import 'package:flutter_clean_architecture/core/error/exception.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/datasources/local_datasource/number_trivia_local_data_source.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String kCachedNumberTrivia = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences preferences;

  NumberTriviaLocalDataSourceImpl({
    required this.preferences,
  });

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) async {
    preferences.setString(kCachedNumberTrivia, triviaToCache.toJson());
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() async {
    String? triviaJson = preferences.getString(kCachedNumberTrivia);
    if (triviaJson == null) {
      throw CacheException();
    }
    return NumberTriviaModel.fromJson(triviaJson);
  }
}
