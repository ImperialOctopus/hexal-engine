import 'package:hexal_engine/model/history.dart';
import 'package:test/test.dart';
import 'package:hexal_engine/model/enums/player.dart';
import 'package:hexal_engine/model/enums/game_over_state.dart';
import 'package:hexal_engine/model/game_state.dart';
import 'package:hexal_engine/model/enums/turn_phase.dart';
import 'package:hexal_engine/state_change/active_player_state_change.dart';

void main() {
  group('Active player state change changes from.', () {
    test('player 2 to player 1.', () {
      final state = const GameState(
        gameOverState: GameOverState.playing,
        cards: [],
        stack: [],
        history: History.empty(),
        activePlayer: Player.two,
        priorityPlayer: Player.one,
        turnPhase: TurnPhase.start,
      );
      final stateChange = const ActivePlayerStateChange(player: Player.one);
      expect(
        state.applyStateChanges([stateChange]).activePlayer,
        Player.one,
      );
    });
    test('player 1 to player 2.', () {
      final state = const GameState(
        gameOverState: GameOverState.playing,
        cards: [],
        stack: [],
        history: History.empty(),
        activePlayer: Player.one,
        priorityPlayer: Player.one,
        turnPhase: TurnPhase.start,
      );
      final stateChange = const ActivePlayerStateChange(player: Player.two);
      expect(
        state.applyStateChanges([stateChange]).activePlayer,
        Player.two,
      );
    });
  });
  test('Active player state change doesn\'t change anything except priority.',
      () {
    final state = const GameState(
      gameOverState: GameOverState.playing,
      cards: [],
      stack: [],
      history: History.empty(),
      activePlayer: Player.one,
      priorityPlayer: Player.one,
      turnPhase: TurnPhase.start,
    );
    final stateChange = const ActivePlayerStateChange(player: Player.two);
    expect(
      state.applyStateChanges([stateChange]),
      const GameState(
        gameOverState: GameOverState.playing,
        cards: [],
        stack: [],
        history: History.empty(),
        activePlayer: Player.two,
        priorityPlayer: Player.one,
        turnPhase: TurnPhase.start,
      ),
    );
  });
}
