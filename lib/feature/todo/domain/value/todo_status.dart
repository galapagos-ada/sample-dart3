import 'package:flutter/material.dart';

sealed class TodoStatus{
  String get statusString;

  static TodoStatus from(String statusString) {
    final notStarted = NotStarted().statusString;
    final inProgress = InProgress().statusString;
    final finished = Finished().statusString; 

    if (statusString == notStarted) {
      return NotStarted();
    } else if (statusString == inProgress) {
      return InProgress();
    } else if (statusString == finished) {
      return Finished();
    } else {
      throw StateError('無効な設定値です');
    }
  }
}

@immutable
final class NotStarted implements TodoStatus{
  @override
  String get statusString => 'NotStarted';
}

@immutable
final class InProgress implements TodoStatus{
  @override
  String get statusString => 'InProgress';
}

@immutable
final class Finished implements TodoStatus{
  @override
  String get statusString => 'Finished';
}
