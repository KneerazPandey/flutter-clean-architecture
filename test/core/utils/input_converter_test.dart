import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/error/failure.dart';
import 'package:flutter_clean_architecture/core/utils/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  test(
    'should return an integer when the string represents and unsigned number',
    () {
      // arrange
      const str = '123';

      // act
      final result = inputConverter.stringToUnsignedInteger(str);

      // assert
      expect(result, const Right(123));
    },
  );

  test(
    'should retun a failure when the string is not an integer',
    () {
      // arrange
      const str = 'a1234';

      // act
      final result = inputConverter.stringToUnsignedInteger(str);

      // assert
      expect(result, Left(InvalidInputFailure()));
    },
  );

  test(
    'should retun a failure [InputInvalidFailure] when the number is string but contain negative',
    () {
      // arrange
      const str = '-1234';

      // act
      final result = inputConverter.stringToUnsignedInteger(str);

      // assert
      expect(result, Left(InvalidInputFailure()));
    },
  );
}
