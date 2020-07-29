import 'package:meta/meta.dart';

import '../event/event.dart';
import '../exceptions/state_change_exception.dart';
import '../game_state/game_state.dart';
import 'state_change.dart';

class RemoveEventStateChange extends StateChange {
  final Event event;

  const RemoveEventStateChange({@required this.event});

  @override
  GameState apply(GameState state) {
    final newStack = state.stack.toList();
    if (newStack.remove(event)) {
      return state.copyWith(stack: newStack);
    } else {
      throw const StateChangeException(
          'RemoveEventStateChange: Provided event not found in stack');
    }
  }

  @override
  List<Object> get props => [event];
}