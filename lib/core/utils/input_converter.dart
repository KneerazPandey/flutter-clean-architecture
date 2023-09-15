import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/error/failure.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String number) {
    try {
      int num = int.parse(number);
      if (num < 0) {
        throw const FormatException();
      }
      return Right(num);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}
