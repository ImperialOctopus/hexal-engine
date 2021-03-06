import 'package:hexal_engine/exceptions/state_change_exception.dart';
import 'package:hexal_engine/model/history.dart';
import 'package:test/test.dart';
import 'package:hexal_engine/event/draw_cards_event.dart';
import 'package:hexal_engine/model/enums/player.dart';
import 'package:hexal_engine/state_change/remove_event_state_change.dart';
import 'package:hexal_engine/model/enums/game_over_state.dart';
import 'package:hexal_engine/model/game_state.dart';
import 'package:hexal_engine/model/enums/turn_phase.dart';

void main() {
  group('Remove stack event state change', () {
    test('removes the specified stack event.', () {
      const event = DrawCardsEvent(player: Player.one, draws: 1);
      const state = GameState(
        gameOverState: GameOverState.playing,
        cards: [],
        stack: [event],
        history: History.empty(),
        activePlayer: Player.one,
        priorityPlayer: Player.one,
        turnPhase: TurnPhase.start,
      );
      const change = RemoveEventStateChange(event: event);
      expect(
        state.applyStateChanges([change]),
        const GameState(
          gameOverState: GameOverState.playing,
          cards: [],
          stack: [],
          history: History.empty(),
          activePlayer: Player.one,
          priorityPlayer: Player.one,
          turnPhase: TurnPhase.start,
        ),
      );
    });
    test('throws a state change exception if the event is not found.', () {
      final state = const GameState(
        gameOverState: GameOverState.playing,
        cards: [],
        stack: [],
        history: History.empty(),
        activePlayer: Player.one,
        priorityPlayer: Player.one,
        turnPhase: TurnPhase.start,
      );
      const change = RemoveEventStateChange(
          event: DrawCardsEvent(player: Player.one, draws: 1));
      expect(
        () => state.applyStateChanges([change]),
        throwsA(isA<StateChangeException>()),
      );
    });
  });
}
