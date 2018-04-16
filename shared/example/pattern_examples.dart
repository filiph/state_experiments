import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class VictorImperative extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialButton(
      child: new Text("Tap me!"),
      onPressed: () async {
        vivienne.updateSign(someData);
        var result = await monica.manufacture(otherData);
        vivienne.updateSign(result);
      },
    );
  }
}

class VictorObservable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialButton(
      child: new Text("Tap me!"),
      onPressed: () async {
        myTable.add(new Order(someData));
        myTable.notifyListeners();
      },
    );
  }
}

class VictorPubsub extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialButton(
      child: new Text("Tap me!"),
      onPressed: () async {
        susan.add(new Order(someData));
      },
    );
  }
}

class MonicaStream extends StatefulWidget {
  final Stream<Order> orderStream;

  MonicaStream({
      Key key,
      this.orderStream,
  }) : super(key: key);

  @override
  MonicaStreamState createState() {
    return new MonicaStreamState();
  }


}

class MonicaStreamState extends State<MonicaStream> {
  StreamSubscription<Order> orderSubscription;

  @override
  void initState() {
    orderSubscription = orderStream.listen(_handleIncoming);
    super.initState();
  }

  @override
  void dispose() {
    orderSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialButton(
      child: new Text("Tap me!"),
      onPressed: () async {
        susan.add(new Order(someData));
      },
    );
  }

  Future<Null> _handleIncoming(Order order) async {
    orderSubscription.pause();
    await _actuallyHandle(order);
    orderSubscription.resume();
  }

  Future<Null> _actuallyHandle(Order o) => new Future.value();
}

final orderStreamController = new StreamController<Order>();

Stream<Order> get orderStream => orderStreamController.stream;

class Susan extends ObservableTable {}

final susan = new Susan();

final myTable = new ObservableTable();

class ObservableTable {
  void add(Order o) {
    // ...
  }

  void notifyListeners() {
    // ...
  }
}

class Order {
  Object data;
  Order(this.data);
}

Object someData = 0;
Object otherData = 0;
Object yetAnotherData = 0;

class Vivienne {
  void updateSign(someData) {
    // ...
  }
}

Vivienne vivienne = new Vivienne();

class Monica {
  Future<Object> manufacture(data) {
    // ...
    return null;
  }
}

Monica monica = new Monica();

abstract class Str<T> {
  Future<bool> any(bool Function(T element) test);

  Stream<E> asyncExpand<E>(Stream<E> Function(T event) convert);

  Stream<E> asyncMap<E>(FutureOr<E> Function(T event) convert);

  Stream<R> cast<R>();

  Future<bool> contains(Object needle);

  Stream distinct([bool Function(T previous, T next) equals]);

  Future<E> drain<E>([E futureValue]);

  Future<bool> every(bool Function(T element) test);
}
