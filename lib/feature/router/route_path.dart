import 'package:flutter/material.dart';

sealed class RoutePath {
  String get path;
}

@immutable
final class RouteTodoList implements RoutePath {
  @override
  String get path => '/';
}

@immutable
final class RouteTodoCreate implements RoutePath {
  @override
  String get path => '/create';
}

@immutable
final class RouteTodoEdit implements RoutePath {
  const RouteTodoEdit({required this.id});
  final int id;

  @override
  String get path => '/edit/$id';
}