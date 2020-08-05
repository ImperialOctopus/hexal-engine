import 'package:meta/meta.dart';

import '../../cards/creature.dart';
import '../../game_state/game_state.dart';
import '../../game_state/location.dart';
import '../../game_state/player.dart';
import '../../objects/card_object.dart';
import '../../objects/game_object.dart';
import 'target.dart';

class CreatureTarget extends Target {
  const CreatureTarget({bool optional = false, @required Player controller})
      : super(controller: controller, optional: optional);

  @override
  bool targetValid(target) {
    return ((target is CardObject) &&
        (target is Creature) &&
        (target.location == Location.field));
  }

  @override
  bool anyValid(GameState state) {
    return state.cards.any((card) => targetValid(card));
  }

  @override
  TargetResult createResult(dynamic target) {
    assert(targetValid(target));
    return CreatureTargetResult(target: target);
  }

  @override
  List<Object> get props => [controller, optional];
}

class CreatureTargetResult extends TargetResult {
  final GameObject target;

  const CreatureTargetResult({@required this.target});

  @override
  List<GameObject> get targets => [target];

  @override
  List<Object> get props => [target];
}
