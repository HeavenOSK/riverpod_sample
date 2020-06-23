import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

class Counter extends StateNotifier<int> {
  Counter() : super(0);

  void increment() => state++;
}

final counterProvider = StateNotifierProvider((ref) => Counter());

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
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
}

class _Count extends HookWidget {
  const _Count({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final count = useProvider(counterProvider.state);

    return Text(count.toString());
  }
}
