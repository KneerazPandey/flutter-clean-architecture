import 'package:flutter_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// user had the internet connection.
  ///
  /// Throws [CacheException] if no cached data is presented.
  Future<NumberTriviaModel> getLastNumberTrivia();

  /// Cached the lastly gotten [NumberTriviaModel] from the internet
  /// when the user had the internet connection.
  ///
  /// Throws [CacheException] if unable to cached the data.
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}
