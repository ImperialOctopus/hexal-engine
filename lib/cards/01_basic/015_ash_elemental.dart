import '../../card/creature.dart';
import '../../card/on_enter_field.dart';
import '../../effects/draw_cards_effect.dart';
import '../../effects/effect.dart';
import '../../models/card.dart';
import '../../models/card_identity.dart';
import '../../models/enums/element.dart';
import '../../models/enums/location.dart';
import '../../models/enums/player.dart';
import '../../models/mana_amount.dart';

/// 2/3 creature with "When this enters the battlefield, draw a card."
class AshElemental extends Card with Creature, OnEnterField {
  @override
  CardIdentity get identity => const CardIdentity(1, 15);
  @override
  Element get element => Element.earth;

  @override
  int get baseAttack => 2;
  @override
  int get baseHealth => 3;

  @override
  ManaAmount get manaCost => const ManaAmount(earth: 1, neutral: 1);

  @override
  List<Effect> get onEnterFieldEffects => [
        DrawCardsEffect(draws: 1, player: controller),
      ];

  @override
  final int damage;

  /// [id] must be unique. [owner] cannot be changed.
  const AshElemental({
    required int id,
    required Player owner,
    required Player controller,
    required Location location,
    required this.damage,
  }) : super(
          id: id,
          owner: owner,
          controller: controller,
          location: location,
        );

  @override
  AshElemental copyWith({
    int? id,
    Player? owner,
    Player? controller,
    Location? location,
  }) =>
      AshElemental(
        id: id ?? this.id,
        owner: owner ?? this.owner,
        controller: controller ?? this.controller,
        location: location ?? this.location,
        damage: damage,
      );

  @override
  AshElemental copyWithCreature({
    int? damage,
  }) =>
      AshElemental(
        id: id,
        owner: owner,
        controller: controller,
        location: location,
        damage: damage ?? this.damage,
      );

  /// Create from json.
  static AshElemental fromJson(List<dynamic> json) => AshElemental(
        id: json[0] as int,
        owner: Player.fromIndex(json[1] as int),
        controller: Player.fromIndex(json[2] as int),
        location: Location.fromIndex(json[3] as int),
        damage: json[4] as int,
      );

  @override
  List<Object> get props => [id, owner, controller, location, damage];
}