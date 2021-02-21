import 'package:hexal_engine/cards/01_basic/000_hivequeen_ngaat.dart';
import 'package:test/test.dart';
import 'package:hexal_engine/actions/pass_action.dart';
import 'package:hexal_engine/actions/play_card_action.dart';
import 'package:hexal_engine/models/enums/player.dart';
import 'package:hexal_engine/models/enums/location.dart';
import 'package:hexal_engine/models/enums/game_over_state.dart';
import 'package:hexal_engine/models/game_state.dart';
import 'package:hexal_engine/models/enums/turn_phase.dart';

void main() {
  group('Card test S1.000', () {
    test('enters the field when played.', () {
      const card = HivequeenNgaat(
        id: 2,
        controller: Player.one,
        owner: Player.one,
        location: Location.hand,
        enteredFieldThisTurn: false,
      );
      var state = const GameState(
        gameOverState: GameOverState.playing,
        cards: [card],
        stack: [],
        activePlayer: Player.one,
        priorityPlayer: Player.one,
        turnPhase: TurnPhase.main1,
      );
      // Game starts in player 1's main phase 1, and player 1 has priority.
      // They have one of this in hand.
      // Player 1 plays this.
      state = state.applyAction(PlayCardAction(card: card.id));

      // This moves into limbo and priority passes.
      expect(state.getCardsByLocation(Player.one, Location.limbo).first,
          isA<HivequeenNgaat>());
      expect(state.priorityPlayer, Player.one);

      // Player 1 keeps priority after playing a card as they are active.
      // They pass, moving priority to player 2.

      state = state.applyAction(PassAction());
      // Player 2 passes. Top item of stack is resolved.
      state = state.applyAction(PassAction());

      expect(state.getCardsByLocation(Player.one, Location.field).first,
          isA<HivequeenNgaat>());
      expect(state.priorityPlayer, Player.one);
    });
  });
}
