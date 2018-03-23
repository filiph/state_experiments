import 'package:reactive_exploration/src/vanilla/main.dart' as vanilla;

enum Architecture {
  vanilla
}

void main() {
  final flavor = Architecture.vanilla;

  print("Running: $flavor");

  switch (flavor) {
    case Architecture.vanilla:
      vanilla.main();
      return;
  }
}