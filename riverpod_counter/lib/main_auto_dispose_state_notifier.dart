import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

part 'main_auto_dispose_state_notifier.g.dart';

class Counter extends StateNotifier<int> {
  Counter() : super(0);

  void increment() => state++;
}

final counterProvider = AutoDisposeStateNotifierProvider<Counter>((ref) {
  ref.onDispose(() {
    print('disposed');
  });
  return Counter();
});

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

@hwidget
Widget myApp() {
  return MaterialApp(
    routes: {
      '/': (_) => FirstPage(),
      '$SecondPage': (_) => SecondPage(),
    },
  );
}

@hwidget
Widget firstPage() {
  final context = useContext();
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

@hwidget
Widget secondPage() {
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

@hwidget
Widget count() {
  final count = useProvider(counterProvider.state);

  return Text(count.toString());
}

@hwidget
Widget dialog() {
  final context = useContext();
  final count = useProvider(counterProvider.state);
  final counter = useProvider(counterProvider);
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
