import '../models/enums/location.dart';
import '../models/enums/player.dart';
import '../models/game_state.dart';
import '../state_changes/modify_event_state_change.dart';
import '../state_changes/move_card_state_change.dart';
import '../state_changes/resolve_event_state_change.dart';
import '../state_changes/state_change.dart';
import 'event.dart';
import 'require_mana_event.dart';

/// Event that channels a card.
class ChannelCardEvent extends Event {
  /// Card to channel.
  final int card;

  /// Card the mana is for.
  final int targetCard;

  /// Controller of the channelling.
  final Player controller;

  /// Event that channels [card].
  const ChannelCardEvent({
    required this.card,
    required this.targetCard,
    required this.controller,
    int id = 0,
    bool resolved = false,
  }) : super(id: id, resolved: resolved);

  @override
  bool valid(GameState state) {
    final _card = state.getCardById(card);

    // Card must be controlled by the controller
    if (_card.controller != controller) {
      return false;
    }

    // Card must be in mana.
    if (_card.location != Location.mana) {
      return false;
    }

    // Check something requires mana.
    if (!state.stack.any((element) =>
        element is RequireManaEvent && element.card == targetCard)) {
      return false;
    }

    return true;
  }

  @override
  List<StateChange> apply(GameState state) {
    if (!valid(state)) {
      return [ResolveEventStateChange(event: this)];
    }

    final _card = state.getCardById(card);

    // Get the require mana event for the target card.
    final event = state.stack.lastWhere((element) =>
            element is RequireManaEvent && element.card == targetCard)
        as RequireManaEvent;

    final newEvent = event.copyWithProvided(_card.providesMana);

    return [
      MoveCardStateChange(card: card, location: Location.exile),
      ModifyEventStateChange(event: event, newEvent: newEvent),
      ResolveEventStateChange(event: this),
    ];
  }

  @override
  ChannelCardEvent copyWithId(int id) => ChannelCardEvent(
        id: id,
        card: card,
        targetCard: targetCard,
        controller: controller,
        resolved: resolved,
      );

  @override
  ChannelCardEvent get copyResolved => ChannelCardEvent(
        id: id,
        card: card,
        targetCard: targetCard,
        controller: controller,
        resolved: true,
      );

  @override
  List<Object> get props => [id, card, targetCard, controller, resolved];

  /// Create this event from json
  static ChannelCardEvent fromJson(List<dynamic> json) => ChannelCardEvent(
        id: json[0] as int,
        card: json[1] as int,
        targetCard: json[2] as int,
        controller: Player.fromIndex(json[3] as int),
        resolved: json[4] as bool,
      );
}