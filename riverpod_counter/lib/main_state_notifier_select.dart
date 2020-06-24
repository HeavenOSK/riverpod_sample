import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

class Count {
  Count({
    this.countA = 0,
    this.countB = 0,
  });
  final int countA;
  final int countB;

  Count copyWith({
    int countA,
    int countB,
  }) {
    return Count(
      countA: countA ?? this.countA,
      countB: countB ?? this.countB,
    );
  }
}

class Counter extends StateNotifier<Count> {
  Counter() : super(Count());

  void incrementA() {
    state = state.copyWith(
      countA: state.countA + 1,
    );
  }

  void incrementB() {
    state = state.copyWith(
      countB: state.countB + 1,
    );
  }
}

final _counterProvider = StateNotifierProvider((ref) => Counter());

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
    final counterNotifier = useProvider(_counterProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Example')),
        body: Center(
          child: _Count(),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
                onPressed: () {
                  counterNotifier.incrementA();
                },
                child: Text('A+1')),
            FloatingActionButton(
              onPressed: () {
                counterNotifier.incrementB();
              },
              child: Text('B+1'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Count extends HookWidget {
  const _Count({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counter = useProvider(
      _counterProvider.state.select((value) => value.countA),
    );
    return Text(counter.toString());
  }
}
