import '../card/on_enter_field.dart';
import '../model/enums/event_state.dart';
import '../model/game_state.dart';
import '../state_change/add_event_state_change.dart';
import '../state_change/modify_event_state_change.dart';
import '../state_change/put_into_field_state_change.dart';
import '../state_change/resolve_event_state_change.dart';
import '../state_change/state_change.dart';
import 'destroy_card_event.dart';
import 'event.dart';
import 'on_card_enter_field_event.dart';

/// Cast a spell or summon a creature.
class CastCardEvent extends Event {
  /// Card to put into field.
  final int card;

  /// Has the card been put into field.
  final bool donePutIntoField;

  /// Spell to cast.
  const CastCardEvent({
    int id = 0,
    EventState state = EventState.unresolved,
    required this.card,
    this.donePutIntoField = false,
  }) : super(id: id, state: state);

  @override
  bool valid(GameState state) {
    // Check card exists and isn't a player.
    // If not it's an error so we let it throw.
    state.getCardById(card);

    return true;
  }

  @override
  List<StateChange> apply(GameState state) {
    if (!valid(state)) {
      return [
        ResolveEventStateChange(event: this, eventState: EventState.failed)
      ];
    }

    final _card = state.getCardById(card);

    if (!donePutIntoField) {
      return [
        PutIntoFieldStateChange(card: card),
        if (_card is OnEnterField)
          AddEventStateChange(event: OnCardEnterFieldEvent(card: card)),
        ModifyEventStateChange(event: this, newEvent: copyDonePutIntoField)
      ];
    } else {
      return [
        if (!_card.permanent)
          AddEventStateChange(event: DestroyCardEvent(card: card)),
        ResolveEventStateChange(event: this, eventState: EventState.succeeded),
      ];
    }
  }

  @override
  CastCardEvent copyWith({int? id, EventState? state}) => CastCardEvent(
        id: id ?? this.id,
        state: state ?? this.state,
        card: card,
        donePutIntoField: donePutIntoField,
      );

  /// Returns a copy of this with donePutIntoField set to true.
  CastCardEvent get copyDonePutIntoField => CastCardEvent(
        id: id,
        card: card,
        donePutIntoField: true,
      );

  @override
  List<Object> get props => [id, state, card, donePutIntoField];

  /// Create this event from json.
  static CastCardEvent fromJson(List<dynamic> json) => CastCardEvent(
        id: json[0] as int,
        state: EventState.fromIndex(json[1] as int),
        card: json[2] as int,
        donePutIntoField: json[3] as bool,
      );
}
