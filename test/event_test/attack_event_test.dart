import 'package:test/test.dart';
import 'package:hexal_engine/state_changes/state_change.dart';
import 'package:hexal_engine/events/attack_event.dart';
import 'package:hexal_engine/events/damage_creature_event.dart';
import 'package:hexal_engine/state_changes/add_event_state_change.dart';
import 'package:hexal_engine/cards/sample/001_cow_creature_card.dart';
import 'package:hexal_engine/models/enums/player.dart';
import 'package:hexal_engine/models/enums/location.dart';
import 'package:hexal_engine/models/enums/game_over_state.dart';
import 'package:hexal_engine/models/game_state.dart';
import 'package:hexal_engine/models/enums/turn_phase.dart';

void main() {
  group('Attack event', () {
    test('deals damage to each creature equal to the other\'s attack.', () {
      const card1 = CowCreatureCard(
        id: 2,
        controller: Player.one,
        owner: Player.one,
        location: Location.field,
        enteredFieldThisTurn: false,
        exhausted: false,
        damage: 0,
      );
      const card2 = CowCreatureCard(
        id: 3,
        controller: Player.two,
        owner: Player.two,
        location: Location.field,
        enteredFieldThisTurn: false,
        exhausted: false,
        damage: 0,
      );
      final state = GameState(
        gameOverState: GameOverState.playing,
        cards: [card1, card2],
        stack: [
          AttackEvent(attacker: card1.toReference, defender: card2.toReference),
        ],
        activePlayer: Player.one,
        priorityPlayer: Player.one,
        turnPhase: TurnPhase.battle,
      );
      final changes = state.resolveTopStackEvent();

      expect(
          changes,
          containsAll(<StateChange>[
            AddEventStateChange(
                event: DamageCreatureEvent(
                    creature: card1.toReference, damage: card2.attack)),
            AddEventStateChange(
                event: DamageCreatureEvent(
                    creature: card2.toReference, damage: card1.attack))
          ]));
    });
  });
}
