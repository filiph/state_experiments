import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _increment() {
    setState(() {
      _counter += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Demo Home Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            Text('$_counter', style: Theme.of(context).textTheme.display1),
          ],
        ),
      ),
      floatingActionButton: Incrementer(_increment),
    );
  }
}

class Incrementer extends StatefulWidget {
  final Function callback;

  Incrementer(this.callback);

  @override
  _IncrementerState createState() => _IncrementerState();
}

class _IncrementerState extends State<Incrementer> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: widget.callback,
      tooltip: 'Increment',
      child: Icon(Icons.add),
    );
  }
}

