import 'package:hexal_engine/model/history.dart';
import 'package:test/test.dart';
import 'package:hexal_engine/state_change/state_change.dart';
import 'package:hexal_engine/event/attack_event.dart';
import 'package:hexal_engine/event/damage_creature_event.dart';
import 'package:hexal_engine/state_change/add_event_state_change.dart';
import 'package:hexal_engine/card_data/00_token/001_cow_creature_card.dart';
import 'package:hexal_engine/model/enums/player.dart';
import 'package:hexal_engine/model/enums/location.dart';
import 'package:hexal_engine/model/enums/game_over_state.dart';
import 'package:hexal_engine/model/game_state.dart';
import 'package:hexal_engine/model/enums/turn_phase.dart';

void main() {
  group('Attack event', () {
    test('deals damage to each creature equal to the other\'s attack.', () {
      const card1 = CowCreatureCard(
        id: 2,
        controller: Player.one,
        owner: Player.one,
        location: Location.field,
        damage: 0,
      );
      const card2 = CowCreatureCard(
        id: 3,
        controller: Player.two,
        owner: Player.two,
        location: Location.field,
        damage: 0,
      );
      final state = GameState(
        gameOverState: GameOverState.playing,
        cards: [card1, card2],
        stack: [
          AttackEvent(attacker: card1.id, defender: card2.id),
        ],
        history: const History.empty(),
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
                    creature: card1.id, damage: card2.attack)),
            AddEventStateChange(
                event: DamageCreatureEvent(
                    creature: card2.id, damage: card1.attack))
          ]));
    });
  });
}
