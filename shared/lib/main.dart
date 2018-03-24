import 'package:reactive_exploration/src/bloc/main.dart' as bloc;
import 'package:reactive_exploration/src/value_notifier/main.dart'
    as value_notifier;
import 'package:reactive_exploration/src/vanilla/main.dart' as vanilla;

void main() {
  final flavor = Architecture.vanilla;

  print("\n\n===== Running: $flavor =====\n\n");

  switch (flavor) {
    case Architecture.vanilla:
      vanilla.main();
      return;
    case Architecture.valueNotifier:
      value_notifier.main();
      return;
    case Architecture.bloc:
      bloc.main();
      return;
  }
}

enum Architecture { bloc, vanilla, valueNotifier }
