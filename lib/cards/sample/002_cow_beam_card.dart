import 'package:hexal_engine/cards/i_on_enter_field.dart';
import 'package:hexal_engine/effect/effect.dart';
import 'package:hexal_engine/objects/card_object.dart';
import 'package:meta/meta.dart';

import 'package:hexal_engine/game_state/location.dart';
import 'package:hexal_engine/game_state/player.dart';

class CowBeamCard extends CardObject implements IOnEnterField {
  @override
  final int id;
  @override
  final Player owner;
  @override
  final Player controller;
  @override
  final Location location;
  @override
  final bool enteredFieldThisTurn;

  const CowBeamCard({
    @required this.id,
    @required this.owner,
    @required this.controller,
    @required this.location,
    @required this.enteredFieldThisTurn,
  });

  @override
  CowBeamCard copyWith(Map<String, dynamic> data) => CowBeamCard(
        id: id,
        owner: owner,
        controller: data['controller'] ?? controller,
        location: data['location'] ?? location,
        enteredFieldThisTurn:
            data['enteredFieldThisTurn'] ?? enteredFieldThisTurn,
      );

  @override
  // TODO: implement onEnterFieldEffects
  List<Effect> get onEnterFieldEffects => throw UnimplementedError();
}
