import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

class Counter extends StateNotifier<int> {
  Counter() : super(0);

  void increment() => state++;
}

final counterProvider = StateNotifierProvider<Counter>((ref) {
  return Counter();
});

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('State Sharing')),
      body: Center(
        child: HomeCount(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => Dialog(),
          );
        },
        child: Icon(Icons.trending_up),
      ),
    );
  }
}

class HomeCount extends HookWidget {
  const HomeCount({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final count = useProvider(counterProvider.state);

    return Text(count.toString());
  }
}

class Dialog extends HookWidget {
  const Dialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counter = useProvider(counterProvider);
    return AlertDialog(
      content: IntrinsicHeight(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 80),
          child: Center(
            child: DialogCount(),
          ),
        ),
      ),
      actions: <Widget>[
        RaisedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('close'),
        ),
        RaisedButton(
          onPressed: () {
            counter.increment();
          },
          child: Icon(Icons.add),
        ),
      ],
    );
  }
}

class DialogCount extends HookWidget {
  const DialogCount({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final count = useProvider(counterProvider.state);

    return Text(count.toString());
  }
}
