import 'dart:async';

import 'package:rxdart/rxdart.dart';

main() async {
  final controller = new PublishSubject<int>();

  final subscription = controller
      .bufferTime(const Duration(milliseconds: 500))
      .listen((list) => print(list));

  await subscription.cancel();

  await controller.close();
}

void _handleIndexes(List<int> event) {
  print(event);
}
