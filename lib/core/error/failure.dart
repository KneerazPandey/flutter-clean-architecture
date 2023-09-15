import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => [];
}

// Creating general failure

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
