import 'package:reactive_exploration/src/bloc/main.dart' as bloc;
import 'package:reactive_exploration/src/bloc_simpler/main.dart'
    as bloc_simpler;
import 'package:reactive_exploration/src/singleton/main.dart' as singleton;
import 'package:reactive_exploration/src/value_notifier/main.dart'
    as value_notifier;
import 'package:reactive_exploration/src/vanilla/main.dart' as vanilla;
import 'package:reactive_exploration/src/scoped/main.dart' as scoped;

void main() {
  final flavor = Architecture.vanilla;

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
    case Architecture.blocSimpler:
      bloc_simpler.main();
      return;
    case Architecture.scoped:
      scoped.main();
      return;
  }
}

enum Architecture {
  bloc,
  blocSimpler,
  scoped,
  singleton,
  vanilla,
  valueNotifier,
}
