import 'package:meta/meta.dart';

import '../game_state/game_state.dart';
import '../objects/card_object.dart';
import '../state_change/combination/put_into_field_state_changes.dart';
import '../state_change/remove_event_state_change.dart';
import '../state_change/state_change.dart';
import 'event.dart';

class PlayCardEvent extends Event {
  final CardObject card;

  const PlayCardEvent({@required this.card});

  @override
  List<StateChange> apply(GameState state) {
    return [
      ...PutIntoFieldStateChanges.generate(card),
      RemoveEventStateChange(event: this)
    ];
  }

  @override
  List<Object> get props => [card];
}
