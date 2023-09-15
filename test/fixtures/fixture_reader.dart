import 'dart:io';

String fixtureReader(String fileName) =>
    File('test/fixtures/$fileName').readAsStringSync();
