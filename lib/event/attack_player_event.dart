import '../card/creature.dart';
import '../model/enums/event_state.dart';
import '../model/enums/location.dart';
import '../model/enums/player.dart';
import '../model/game_state.dart';
import '../state_change/add_event_state_change.dart';
import '../state_change/history_attacked_state_change.dart';
import '../state_change/resolve_event_state_change.dart';
import '../state_change/set_counter_available_state_change.dart';
import '../state_change/state_change.dart';
import 'damage_player_event.dart';
import 'event.dart';

/// Event for a creature attacking a player.
class AttackPlayerEvent extends Event {
  /// Creature attacking.
  final int attacker;

  /// Player being attacked.
  final Player player;

  /// Should this enable counterattacks this turn?
  final bool enableCounter;

  /// [attacker] attacks [player]. Exhausts attacker if [exhaustAttacker].
  /// Enables counterattacks this turn if [enableCounter].
  const AttackPlayerEvent({
    int id = 0,
    EventState state = EventState.unresolved,
    required this.attacker,
    required this.player,
    this.enableCounter = true,
  }) : super(id: id, state: state);

  @override
  bool valid(GameState state) {
    final _attacker = state.getCardById(attacker);

    // Check if attacker is valid
    if (!(_attacker is Creature) || _attacker.location != Location.field) {
      return false;
    }

    return true;
  }

  @override
  List<StateChange> apply(GameState state) {
    if (!valid(state)) {
      return [
        ResolveEventStateChange(event: this, eventState: EventState.failed)
      ];
    }

    // Casts safe because of valid check above.
    final _attacker = state.getCardById(attacker) as Creature;
    final _player = Player.fromIndex(player.index);

    return [
      AddEventStateChange(
          event: DamagePlayerEvent(player: _player, damage: _attacker.attack)),
      ...enableCounter
          ? [const SetCounterAvailableStateChange(enabled: true)]
          : [],
      // Add this attack to the history.
      HistoryAttackedStateChange(creature: attacker),
      ResolveEventStateChange(event: this, eventState: EventState.succeeded),
    ];
  }

  @override
  AttackPlayerEvent copyWith({int? id, EventState? state}) => AttackPlayerEvent(
        id: id ?? this.id,
        state: state ?? this.state,
        attacker: attacker,
        player: player,
        enableCounter: enableCounter,
      );

  @override
  List<Object> get props => [id, state, attacker, player, enableCounter];

  /// Create this event from json.
  static AttackPlayerEvent fromJson(List<dynamic> json) => AttackPlayerEvent(
        id: json[0] as int,
        state: EventState.fromIndex(json[1] as int),
        attacker: json[2] as int,
        player: Player.fromIndex(json[3] as int),
        enableCounter: json[4] as bool,
      );
}
