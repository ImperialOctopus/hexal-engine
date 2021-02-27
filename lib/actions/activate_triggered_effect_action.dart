import '../card/on_trigger.dart';
import '../exceptions/action_exception.dart';
import '../models/game_state.dart';
import '../state_changes/add_event_state_change.dart';
import '../state_changes/history_triggered_effect_state_change.dart';
import '../state_changes/state_change.dart';
import 'action.dart';

/// Activates a triggered effect.
class ActivateTriggeredEffectAction extends Action {
  /// Id of card that holds effect.
  final int card;

  /// Index of effect to activate.
  final int effectIndex;

  /// Activates a triggered effect.
  const ActivateTriggeredEffectAction({
    required this.card,
    this.effectIndex = 0,
  });

  @override
  bool valid(GameState state) {
    final _card = state.getCardById(card);

    // Check card has a triggered effect.
    if (_card is! OnTrigger) {
      return false;
    }
    // Check effect index is in range.
    if (effectIndex > _card.onTriggerEffects.length - 1) {
      return false;
    }

    final _effect = _card.onTriggerEffects[effectIndex];
    // Check effect has triggered.
    if (!_effect.trigger(state)) {
      return false;
    }
    // Check effect hasn't already happened for this trigger.
    if (_effect.historyBuilder != null &&
        state.history.triggeredEffects
            .contains(_effect.historyBuilder!(state))) {
      return false;
    }

    return true;
  }

  @override
  List<StateChange> apply(GameState state) {
    if (!valid(state)) {
      throw const ActionException(
          'Activate triggered effect failed: Invalid argument');
    }

    final _card = state.getCardById(card) as OnTrigger;
    final _effect = _card.onTriggerEffects[effectIndex];

    return [
      AddEventStateChange(event: _effect.effectBuilder(state)),
      if (_effect.historyBuilder != null)
        HistoryTriggeredEffectStateChange(
            historyTriggeredEffect: _effect.historyBuilder!(state)),
    ];
  }

  @override
  List<Object> get props => [card, effectIndex];

  /// Create from json.
  static ActivateTriggeredEffectAction fromJson(List<dynamic> json) =>
      ActivateTriggeredEffectAction(
        card: json[0] as int,
        effectIndex: json[1] as int,
      );
}
