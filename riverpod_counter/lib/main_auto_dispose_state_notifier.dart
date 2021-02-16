import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

class Counter extends StateNotifier<int> {
  Counter() : super(0);

  void increment() => state++;
}

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
      routes: {
        '/': (_) => FirstPage(),
        '$SecondPage': (_) => SecondPage(),
      },
    );
  }
}

class FirstPage extends HookWidget {
  const FirstPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('$SecondPage');
              },
              child: Text('Next Page'),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends HookWidget {
  const SecondPage({Key key}) : super(key: key);

  static final counterProvider =
      StateNotifierProvider.autoDispose<Counter>((ref) {
    ref.onDispose(() {
      print('disposed');
    });
    return Counter();
  });

  @override
  Widget build(BuildContext context) {
    final counter = useProvider(counterProvider);
    final context = useContext();

    return Scaffold(
      appBar: AppBar(title: Text('Second Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Count(),
            RaisedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return Dialog();
                    });
              },
              child: Text('Dialog'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counter.increment();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Count extends HookWidget {
  const Count({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final count = useProvider(SecondPage.counterProvider.state);

    return Text(count.toString());
  }
}

class Dialog extends HookWidget {
  const Dialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final count = useProvider(SecondPage.counterProvider.state);
    final counter = useProvider(SecondPage.counterProvider);
    return AlertDialog(
      content: IntrinsicHeight(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 80),
          child: Center(child: Text(count.toString())),
        ),
      ),
      actions: <Widget>[
        RaisedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('閉じる'),
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
