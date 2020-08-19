import 'package:test/test.dart';
import 'package:hexal_engine/actions/attack_player_action.dart';
import 'package:hexal_engine/cards/sample/001_cow_creature_card.dart';
import 'package:hexal_engine/events/attack_player_event.dart';
import 'package:hexal_engine/models/location.dart';
import 'package:hexal_engine/state_changes/add_event_state_change.dart';
import 'package:hexal_engine/models/player.dart';
import 'package:hexal_engine/models/game_over_state.dart';
import 'package:hexal_engine/models/game_state.dart';
import 'package:hexal_engine/models/turn_phase.dart';

void main() {
  group('Attack player action test', () {
    test('adds attack event to the stack. ', () {
      const attacker = CowCreatureCard(
        id: 2,
        controller: Player.one,
        owner: Player.one,
        location: Location.field,
        enteredFieldThisTurn: false,
        exhausted: false,
        damage: 0,
      );
      final state = const GameState(
        gameOverState: GameOverState.playing,
        cards: [attacker],
        stack: [],
        activePlayer: Player.one,
        priorityPlayer: Player.one,
        turnPhase: TurnPhase.battle,
      );
      const action = AttackPlayerAction(attacker: attacker, player: Player.two);
      final change = state.generateStateChanges(action);

      expect(
          change,
          contains(AddEventStateChange(
              event:
                  AttackPlayerEvent(attacker: attacker, player: Player.two))));
    });
  });
}
