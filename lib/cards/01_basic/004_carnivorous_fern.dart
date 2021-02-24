import '../../card/creature.dart';
import '../../card/ready.dart';
import '../../models/card.dart';
import '../../models/card_identity.dart';
import '../../models/enums/location.dart';
import '../../models/enums/player.dart';

/// 1/2 vanilla creature.
class CarnivorousFern extends Card with Creature, Ready {
  @override
  CardIdentity get identity => const CardIdentity(1, 4);

  @override
  int get baseAttack => 2;
  @override
  int get baseHealth => 1;

  /// [id] must be unique. [owner] cannot be changed.
  const CarnivorousFern({
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
  final int damage;

  @override
  CarnivorousFern copyWith({
    int? id,
    Player? owner,
    Player? controller,
    Location? location,
  }) =>
      CarnivorousFern(
        id: id ?? this.id,
        owner: owner ?? this.owner,
        controller: controller ?? this.controller,
        location: location ?? this.location,
        damage: damage,
      );

  @override
  CarnivorousFern copyWithCreature({
    int? damage,
  }) =>
      CarnivorousFern(
        id: id,
        owner: owner,
        controller: controller,
        location: location,
        damage: damage ?? this.damage,
      );

  /// Create from json.
  static CarnivorousFern fromJson(List<dynamic> json) => CarnivorousFern(
        id: json[0] as int,
        owner: Player.fromIndex(json[1] as int),
        controller: Player.fromIndex(json[2] as int),
        location: Location.fromIndex(json[3] as int),
        damage: json[6] as int,
      );

  @override
  List<Object> get props => [id, owner, controller, location, damage];
}
