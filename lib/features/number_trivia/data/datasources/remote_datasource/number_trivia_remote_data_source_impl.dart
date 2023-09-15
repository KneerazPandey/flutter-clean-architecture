import 'package:http/http.dart' as http;

import '../../../../../core/error/exception.dart';
import '../../models/number_trivia_model.dart';
import 'number_trivia_remote_data_source.dart';

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({
    required this.client,
  });

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    return _getTriviaFromURL('http://numbersapi.com/$number');
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    return _getTriviaFromURL('http://numbersapi.com/random');
  }

  Future<NumberTriviaModel> _getTriviaFromURL(String url) async {
    try {
      Uri uri = Uri.parse(url);
      final http.Response response = await client.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return NumberTriviaModel.fromJson(response.body);
      } else {
        throw ServerException();
      }
    } on Exception {
      throw ServerException();
    }
  }
}
