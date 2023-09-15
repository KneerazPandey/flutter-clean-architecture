import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_clean_architecture/core/error/failure.dart';
import 'package:flutter_clean_architecture/core/usecase/usecase.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';

import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia extends UseCase<NumberTrivia, ConcreteParams> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(ConcreteParams params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class ConcreteParams extends Equatable {
  final int number;

  const ConcreteParams({
    required this.number,
  });

  @override
  List<Object?> get props => [number];
}
