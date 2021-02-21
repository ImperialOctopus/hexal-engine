import '../card/creature.dart';
import '../models/enums/location.dart';
import '../models/game_state.dart';
import '../state_changes/add_event_state_change.dart';
import '../state_changes/exhaust_creature_state_change.dart';
import '../state_changes/resolve_event_state_change.dart';
import '../state_changes/set_counter_available_state_change.dart';
import '../state_changes/state_change.dart';
import 'damage_creature_event.dart';
import 'event.dart';

/// Event representing one creature attacking another.
class AttackEvent extends Event {
  /// Creature that is attacking.
  final int attacker;

  /// Creature being attacked.
  final int defender;

  /// Should the attacker be exhausted?
  final bool exhaustAttacker;

  /// Should this enable counterattacks this turn?
  final bool enableCounter;

  @override
  final bool resolved;

  /// [attacker] attacks [defender]. Exhausts attacker if [exhaustAttacker].
  /// Enables counterattacks this turn if [enableCounter].
  const AttackEvent({
    required this.attacker,
    required this.defender,
    this.exhaustAttacker = true,
    this.enableCounter = true,
    this.resolved = false,
  });

  @override
  bool valid(GameState state) {
    // Get cards from state
    final _attacker = state.getCardById(attacker);
    final _defender = state.getCardById(defender);

    // Check cards are creatures.
    if (!(_attacker is Creature) || !(_defender is Creature)) {
      return false;
    }

    // Check target creature is still on the field.
    if (_attacker.location != Location.field ||
        _defender.location != Location.field) {
      return false;
    }

    return true;
  }

  @override
  List<StateChange> apply(GameState state) {
    if (!valid(state)) {
      return [ResolveEventStateChange(event: this)];
    }

    // Get cards from state
    final _attacker = state.getCardById(attacker) as Creature;
    final _defender = state.getCardById(defender) as Creature;

    return [
      AddEventStateChange(
          event: DamageCreatureEvent(
              creature: attacker, damage: _defender.attack)),
      AddEventStateChange(
          event: DamageCreatureEvent(
              creature: defender, damage: _attacker.attack)),
      ...exhaustAttacker
          ? [ExhaustCreatureStateChange(creature: attacker)]
          : [],
      ...enableCounter
          ? [const SetCounterAvailableStateChange(enabled: true)]
          : [],
      ResolveEventStateChange(event: this),
    ];
  }

  @override
  AttackEvent get copyResolved => AttackEvent(
      attacker: attacker,
      defender: defender,
      exhaustAttacker: exhaustAttacker,
      enableCounter: enableCounter,
      resolved: true);

  @override
  List<Object> get props =>
      [attacker, defender, exhaustAttacker, enableCounter, resolved];

  /// Create this event from json.
  static AttackEvent fromJson(List<dynamic> json) => AttackEvent(
      attacker: int.parse(json[0].toString()),
      defender: int.parse(json[1].toString()),
      exhaustAttacker: json[2] as bool,
      enableCounter: json[3] as bool,
      resolved: json[4] as bool);
}
