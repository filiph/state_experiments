import 'package:reactive_exploration/src/bloc/main.dart' as bloc;
import 'package:reactive_exploration/src/bloc_start/main.dart' as bloc_start;
import 'package:reactive_exploration/src/scoped/start.dart' as scoped;
import 'package:reactive_exploration/src/singleton/main.dart' as singleton;
import 'package:reactive_exploration/src/start/main.dart' as start;
import 'package:reactive_exploration/src/start/main_blob.dart' as start_blob;
import 'package:reactive_exploration/src/value_notifier/main.dart'
    as value_notifier;
import 'package:reactive_exploration/src/vanilla/main.dart' as vanilla;
import 'package:reactive_exploration/src/redux/main.dart' as redux;

void main() {
  final flavor = Architecture.vanilla;

  print("\n\n===== Running: $flavor =====\n\n");

  switch (flavor) {
    case Architecture.start:
      start.main();
      return;
    case Architecture.startBlob:
      start_blob.main();
      return;
    case Architecture.singleton:
      singleton.main();
      return;
    case Architecture.vanilla:
      vanilla.main();
      return;
    case Architecture.valueNotifier:
      value_notifier.main();
      return;
    case Architecture.bloc:
      bloc.main();
      return;
    case Architecture.blocStart:
      bloc_start.main();
      return;
    case Architecture.scoped:
      scoped.main();
      return;
    case Architecture.redux:
      redux.main();
      return;
  }
}

enum Architecture {
  bloc,
  blocStart,
  scoped,
  singleton,
  start,
  startBlob,
  vanilla,
  valueNotifier,
  redux,
}
