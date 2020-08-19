import 'package:test/test.dart';
import 'package:hexal_engine/events/draw_card_event.dart';
import 'package:hexal_engine/models/player.dart';
import 'package:hexal_engine/state_changes/add_event_state_change.dart';
import 'package:hexal_engine/models/game_over_state.dart';
import 'package:hexal_engine/models/game_state.dart';
import 'package:hexal_engine/models/turn_phase.dart';

void main() {
  test('Add stack event state change adds event to stack.', () {
    final event = DrawCardEvent(player: Player.one, draws: 1);
    final state = const GameState(
      gameOverState: GameOverState.playing,
      cards: [],
      stack: [],
      activePlayer: Player.one,
      priorityPlayer: Player.one,
      turnPhase: TurnPhase.start,
    );
    final stateChange = AddEventStateChange(event: event);
    expect(
      state.applyStateChanges([stateChange]).stack,
      [event],
    );
  });
}
