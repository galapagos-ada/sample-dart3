import 'package:dart3_sample/feature/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {

  runApp(const ProviderScope(child: AppRouter()));
}
