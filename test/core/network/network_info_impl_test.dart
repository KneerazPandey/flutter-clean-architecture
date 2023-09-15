import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_clean_architecture/core/network/network_info_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectivityPlus extends Mock implements Connectivity {}

void main() {
  late MockConnectivityPlus connectivityPlus = MockConnectivityPlus();
  late NetworkInfoImpl networkInfoImpl = NetworkInfoImpl(connectivityPlus);

  group(
    'isConnected',
    () {
      test(
        'should return true when the internet is connected',
        () async {
          // arrange
          when(() => connectivityPlus.checkConnectivity())
              .thenAnswer((invocation) async => ConnectivityResult.wifi);

          // act
          final result = await networkInfoImpl.isConnected;

          // assert
          expect(result, equals(true));
        },
      );
    },
  );

  group(
    'isNotConnected',
    () {
      test(
        'should return false when the internet is not connected',
        () async {
          // arrange
          when(() => connectivityPlus.checkConnectivity())
              .thenAnswer((invocation) async => ConnectivityResult.none);

          // act
          final result = await networkInfoImpl.isConnected;

          // assert
          expect(result, equals(false));
        },
      );
    },
  );
}
