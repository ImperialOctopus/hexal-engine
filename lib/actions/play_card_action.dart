import 'package:meta/meta.dart';

import '../event/play_card_event.dart';
import '../exceptions/action_exception.dart';
import '../game_state/game_state.dart';
import '../game_state/location.dart';
import '../objects/card_object.dart';
import '../state_change/add_event_state_change.dart';
import '../state_change/move_card_state_change.dart';
import '../state_change/priority_state_change.dart';
import '../state_change/state_change.dart';
import 'action.dart';

class PlayCardAction extends Action {
  final CardObject card;

  const PlayCardAction({@required this.card});

  @override
  bool valid(GameState state) {
    if (state.stack.isNotEmpty) {
      // Cannot play cards if stack is not empty.
      return false;
    }
    if (!state
        .getCardsByLocation(state.priorityPlayer, Location.hand)
        .contains(card)) {
      // Card not found in hand.
      return false;
    }
    if (state.activePlayer != state.priorityPlayer) {
      // Cannot play card on opponent's turn.
      return false;
    }
    return true;
  }

  @override
  List<StateChange> apply(GameState state) {
    if (!valid(state)) {
      throw const ActionException('PlayCardAction Exception: invalid argument');
    }
    return [
      MoveCardStateChange(card: card, location: Location.limbo),
      AddEventStateChange(event: PlayCardEvent(card: card)),
      PriorityStateChange(player: state.activePlayer),
    ];
  }

  @override
  List<Object> get props => [card];
}
