import '../cards/creature.dart';
import '../events/attack_event.dart';
import '../exceptions/action_exception.dart';
import '../models/game_state.dart';
import '../models/location.dart';
import '../models/turn_phase.dart';
import '../state_changes/add_event_state_change.dart';
import '../state_changes/priority_state_change.dart';
import '../state_changes/state_change.dart';
import 'action.dart';

/// Declares an attack targeting a creature.
class AttackAction extends Action {
  /// Creature attacking.
  final Creature attacker;

  /// Creature defending.
  final Creature defender;

  /// Causes [attacker] to attack [defender].
  const AttackAction({required this.attacker, required this.defender});

  @override
  bool valid(GameState state) {
    // Attack cannot be a reaction.
    if (state.stack.isNotEmpty) {
      return false;
    }

    // Check attacker is valid
    // Cannot control opponent's creatures.
    if (attacker.controller != state.priorityPlayer) {
      return false;
    }

    // Normal attack.
    if (state.turnPhase == TurnPhase.battle) {
      // Can't attack on your opponent's turn.
      if (attacker.controller != state.activePlayer) {
        return false;
      }

      // Check if attacker can attack.
      if (!attacker.canAttack) {
        return false;
      }

      // Cannot attack your own creatures
      if (defender.controller == state.activePlayer) {
        return false;
      }

      // Check if creature is being protected.
      if (!defender.canBeAttacked) {
        return false;
      }

      // Cannot attack creatures not in field.
      if (defender.location != Location.field) {
        return false;
      }

      return true;
    }

    // Counterattack.
    if (state.turnPhase == TurnPhase.counter) {
      // Can't counter on your turn.
      if (attacker.controller != state.notActivePlayer) {
        return false;
      }

      // Check if attacker can attack.
      if (!attacker.canAttack) {
        return false;
      }

      // Check if creature is being protected.
      if (!defender.canBeAttacked) {
        return false;
      }

      // Cannot attack your own creatures
      if (defender.controller == state.activePlayer) {
        return false;
      }

      // Cannot attack creatures not in field.
      if (defender.location != Location.field) {
        return false;
      }

      return true;
    }

    // Not in the correct phase.
    return false;
  }

  @override
  List<StateChange> apply(GameState state) {
    if (!valid(state)) {
      throw const ActionException('AttackAction Exception: Attack not valid');
    }
    return [
      AddEventStateChange(
          event: AttackEvent(attacker: attacker, defender: defender)),
      PriorityStateChange(player: state.activePlayer),
    ];
  }

  @override
  List<Object> get props => [attacker, defender];
}
