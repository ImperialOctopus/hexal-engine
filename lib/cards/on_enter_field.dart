import '../effects/effect.dart';
import '../models/card.dart';

/// Has an onEnterField effect.
mixin OnEnterField on Card {
  /// List of effects triggered when this enters the field.
  List<Effect> get onEnterFieldEffects;
}
