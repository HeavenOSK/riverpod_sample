import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

part 'main.g.dart';

class Counter extends StateNotifier<int> {
  Counter() : super(0);

  void increment() => state++;
}

final counterProvider = StateNotifierProvider((ref) => Counter());

void main() {
  runApp(
    ProviderScope(
      child: _MyApp(),
    ),
  );
}

@hwidget
Widget _myApp() {
  final counterNotifier = useProvider(counterProvider);

  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Example')),
      body: Center(
        child: _Count(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counterNotifier.increment();
        },
        child: Icon(Icons.add),
      ),
    ),
  );
}

@hwidget
Widget _count() {
  final count = useProvider(counterProvider.state);

  return Text(count.toString());
}
