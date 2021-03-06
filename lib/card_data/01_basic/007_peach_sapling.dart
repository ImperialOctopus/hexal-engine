import '../../card/creature.dart';
import '../../card/on_enter_field.dart';
import '../../effect/draw_cards_effect.dart';
import '../../effect/effect.dart';
import '../../card/card.dart';
import '../../model/card_identity.dart';
import '../../model/enums/element.dart';
import '../../model/enums/location.dart';
import '../../model/enums/player.dart';

/// 1/2 vanilla creature.
class PeachSapling extends Card with Creature, OnEnterField {
  @override
  CardIdentity get identity => const CardIdentity(1, 7);
  @override
  Element get element => Element.earth;

  @override
  int get baseAttack => 1;
  @override
  int get baseHealth => 1;

  @override
  List<Effect> get onEnterFieldEffects =>
      [DrawCardsEffect(player: controller, draws: 1)];

  /// [id] must be unique. [owner] cannot be changed.
  const PeachSapling({
    int id = 0,
    Player owner = Player.one,
    Player controller = Player.one,
    Location location = Location.deck,
    this.damage = 0,
  }) : super(
          id: id,
          owner: owner,
          controller: controller,
          location: location,
        );

  @override
  final int damage;

  @override
  PeachSapling copyWith({
    int? id,
    Player? owner,
    Player? controller,
    Location? location,
  }) =>
      PeachSapling(
        id: id ?? this.id,
        owner: owner ?? this.owner,
        controller: controller ?? this.controller,
        location: location ?? this.location,
        damage: damage,
      );

  @override
  PeachSapling copyWithCreature({
    bool? exhausted,
    bool? enteredFieldThisTurn,
    int? damage,
  }) =>
      PeachSapling(
        id: id,
        owner: owner,
        controller: controller,
        location: location,
        damage: damage ?? this.damage,
      );
}
