import '../card/creature.dart';
import '../events/damage_creature_event.dart';
import '../events/damage_player_event.dart';
import '../models/enums/player.dart';
import '../models/game_state.dart';
import '../state_changes/add_event_state_change.dart';
import '../state_changes/modify_event_state_change.dart';
import '../state_changes/resolve_event_state_change.dart';
import '../state_changes/state_change.dart';
import 'effect.dart';
import 'target/target.dart';
import 'targeted_effect.dart';

/// Deals damage to a target.
class DamageEffect extends Effect with TargetedEffect {
  /// Amount of damage to deal.
  final int damage;

  // Fields overridden from targeted effect
  @override
  final Player controller;
  @override
  final Target target;
  @override
  final bool targetFilled;
  @override
  final List<int> targets;

  /// [target] is target to request. [targetResult] returns from the request.
  /// [targetIndex] counts through list of targets to apply damage.
  const DamageEffect({
    int id = 0,
    required this.controller,
    required this.damage,
    required this.target,
    this.targetFilled = false,
    this.targets = const [],
  }) : super(id: id);

  @override
  bool valid(GameState state) {
    // Target should be filled before this is applied.
    if (!targetFilled) {
      return false;
    }

    // Check all targets exist in state.
    for (final ref in targets) {
      state.getCardById(ref);
    }

    return true;
  }

  @override
  List<StateChange> apply(GameState state) {
    if (!valid(state)) {
      return [ResolveEventStateChange(event: this)];
    }

    if (targets.isEmpty) {
      // If there are no targets, resolve this.
      return [ResolveEventStateChange(event: this)];
    }

    // If only one target is left, do it and resolve
    if (targets.length == 1) {
      return [
        _generateStateChange(state, targets.first),
        ResolveEventStateChange(event: this),
      ];
    }

    // Otherwise do one target and increment
    return [
      _generateStateChange(state, targets.first),
      ModifyEventStateChange(
        event: this,
        newEvent: DamageEffect(
          damage: damage,
          target: target,
          targetFilled: targetFilled,
          targets: targets.skip(1).toList(),
          controller: controller,
        ),
      ),
    ];
  }

  StateChange _generateStateChange(GameState state, int reference) {
    // If target is a player.
    if (reference < 2) {
      return AddEventStateChange(
          event: DamagePlayerEvent(
              player: Player.fromIndex(reference), damage: damage));
    } else {
      final _object = state.getCardById(reference);

      if (_object is Creature) {
        return AddEventStateChange(
            event: DamageCreatureEvent(creature: reference, damage: damage));
      } else {
        throw ArgumentError(
            'ID provided to damage effect was not a player or creature.');
      }
    }
  }

  @override
  DamageEffect copyWithId(int id) => DamageEffect(
        id: id,
        damage: damage,
        target: target,
        targetFilled: targetFilled,
        targets: targets,
        controller: controller,
      );

  @override
  DamageEffect copyFilled(List<int> _targets) => DamageEffect(
        id: id,
        damage: damage,
        target: target,
        targetFilled: true,
        targets: _targets,
        controller: controller,
      );

  @override
  List<Object> get props => [
        id,
        damage,
        target,
        targetFilled,
        targets,
        controller,
      ];

  /// Create this effect from json.
  static DamageEffect fromJson(List<dynamic> json) => DamageEffect(
        id: json[0] as int,
        damage: json[1] as int,
        target: Target.fromJson(json[2] as Map<String, dynamic>),
        targetFilled: json[3] as bool,
        targets:
            (json[4] as List<dynamic>).map((dynamic e) => e as int).toList(),
        controller: Player.fromIndex(json[5] as int),
      );
}
