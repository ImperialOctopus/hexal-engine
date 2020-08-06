import 'package:test/test.dart';
import 'package:hexal_engine/actions/pass_action.dart';
import 'package:hexal_engine/objects/card_object.dart';
import 'package:hexal_engine/state_change/game_over_state_change.dart';
import 'package:hexal_engine/cards/sample/000_test_card.dart';
import 'package:hexal_engine/event/damage_player_event.dart';
import 'package:hexal_engine/game_state/player.dart';
import 'package:hexal_engine/game_state/location.dart';
import 'package:hexal_engine/state_change/move_card_state_change.dart';
import 'package:hexal_engine/game_state/game_over_state.dart';
import 'package:hexal_engine/game_state/game_state.dart';
import 'package:hexal_engine/game_state/turn_phase.dart';

void main() {
  group('Damage player event', () {
    test('deals 1 damage and resolves if damage is 1. ', () {
      const card = TestCard(
        id: 2,
        controller: Player.one,
        owner: Player.one,
        location: Location.deck,
      );
      final state = const GameState(
        gameOverState: GameOverState.playing,
        cards: [card],
        stack: [
          DamagePlayerEvent(player: Player.one, damage: 1),
        ],
        activePlayer: Player.one,
        priorityPlayer: Player.one,
        turnPhase: TurnPhase.draw,
      );
      final changes = state.resolveTopStackEvent();

      expect(changes,
          contains(MoveCardStateChange(card: card, location: Location.exile)));
    });
    test('deals 1 damage and resolves if damage is 1. ', () {
      const card1 = TestCard(
        id: 2,
        controller: Player.one,
        owner: Player.one,
        location: Location.deck,
      );
      const card2 = TestCard(
        id: 3,
        controller: Player.one,
        owner: Player.one,
        location: Location.deck,
      );
      var state = const GameState(
        gameOverState: GameOverState.playing,
        cards: [card1, card2],
        stack: [
          DamagePlayerEvent(player: Player.one, damage: 2),
        ],
        activePlayer: Player.one,
        priorityPlayer: Player.one,
        turnPhase: TurnPhase.draw,
      );
      // Both players pass for first damage
      state = state.applyAction(PassAction());
      state = state.applyAction(PassAction());
      // Both players pass for second damage
      state = state.applyAction(PassAction());
      state = state.applyAction(PassAction());
      // Expect player 1 to have exiled two cards from their deck.
      expect(state.cards, <CardObject>[
        card1.copyWithBase(location: Location.exile),
        card2.copyWithBase(location: Location.exile),
      ]);
    });
    test('triggers game over if the player has no cards. ', () {
      final state = const GameState(
        gameOverState: GameOverState.playing,
        cards: [],
        stack: [
          DamagePlayerEvent(player: Player.one, damage: 1),
        ],
        activePlayer: Player.one,
        priorityPlayer: Player.one,
        turnPhase: TurnPhase.draw,
      );
      final changes = state.resolveTopStackEvent();

      expect(
          changes,
          contains(
              GameOverStateChange(gameOverState: GameOverState.player2Win)));
    });
  });
}
