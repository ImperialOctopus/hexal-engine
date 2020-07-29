import '../../cards/mi_creature.dart';
import 'target.dart';
import '../../exceptions/event_exceptipn.dart';
import '../../game_state/location.dart';
import '../../objects/card_object.dart';
import '../../objects/game_object.dart';
import 'package:meta/meta.dart';

class CreatureTarget extends Target {
  final bool optional;

  const CreatureTarget({this.optional = false});

  @override
  bool targetValid(target) => ((target is CardObject) &&
      (target is ICreature) &&
      (target.location == Location.battlefield));

  @override
  CreatureTargetResult createResult(dynamic target) {
    if (!targetValid(target)) {
      throw EventException('Create target result failed: invalid target');
    }
    return CreatureTargetResult(target: target);
  }

  @override
  List<Object> get props => [];
}

class CreatureTargetResult extends TargetResult {
  final GameObject target;

  const CreatureTargetResult({@required this.target});

  @override
  List<Object> get props => [target];
}