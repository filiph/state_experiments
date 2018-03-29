import 'package:reactive_exploration/src/bloc/main.dart' as bloc;
import 'package:reactive_exploration/src/singleton/main.dart' as singleton;
import 'package:reactive_exploration/src/value_notifier/main.dart'
    as value_notifier;
import 'package:reactive_exploration/src/vanilla/main.dart' as vanilla;
import 'package:reactive_exploration/src/scoped/main.dart' as scoped;

void main() {
  final flavor = Architecture.scoped;

  print("\n\n===== Running: $flavor =====\n\n");

  switch (flavor) {
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
    case Architecture.scoped:
      scoped.main();
      return;
  }
}

enum Architecture {
  bloc,
  singleton,
  vanilla,
  valueNotifier,
  scoped,
}
