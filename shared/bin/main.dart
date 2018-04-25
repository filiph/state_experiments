import 'dart:async';
import 'dart:io';

var currentKey = "none";

class Store {
  String _value;

  void dispatch(Action action) {
    _value = action.payload;
  }

  State getState() {
    throw UnimplementedError();
  }
}

class Action {
  ActionType type;
  Object payload;
}

// In JavaScript, action types are recommended to be String, because Strings
// are serializable. In Dart, we can start with regular Enum, and switch
// to EnumClass later (without changing the API).
enum ActionType {
  increment,
  decrement
}

class State {
  int counter;

  State(this.counter);
}

final initState = State(0);

State projectRedux(State state, Action action) {
  switch (action.type) {
    case ActionType.increment:
      return State(state.counter + 1);
    case ActionType.decrement:
      return State(state.counter -1);
    default:
      return state;
  }
}


void main() {
  stdin.lineMode = false;
  stdin.listen((bytes) => currentKey = String.fromCharCodes(bytes));

  Timer.periodic(const Duration(milliseconds: 100), (_) {
    print("Current key: $currentKey");
  });
}
