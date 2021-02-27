import '../../events/cast_card_event.dart';
import '../../models/card.dart';
import '../../models/enums/element.dart';
import '../../models/game_state.dart';
import '../../models/history_triggered_effect.dart';
import 'triggered_effect.dart';

/// Trigger for summoning a creature with the provided element.
Trigger onSummonFriendlyElementalCreature(
    Card card, Element element, int effectId) {
  bool function(GameState state) {
    // Check the top stack event is a summon creature event.
    final topEvent = state.stack.last;
    if (topEvent is! CastCardEvent || !topEvent.donePutIntoField) {
      return false;
    }

    final _card = state.getCardById(topEvent.card);
    // Check the card element matches.
    if (_card.element != element) {
      return false;
    }
    // Check the creature is friendly.
    if (_card.controller != card.controller) {
      return false;
    }

    // See if we've reacted to this event already.
    if (state.history.triggeredEffects.contains(
        onSummonFriendlyElementalCreatureHistory(card, element, effectId)(
            state))) {
      return false;
    }

    // All checks passed.
    return true;
  }

  return function;
}

/// History for onSummonFriendlyElementalCreature.
EffectHistoryBuilder onSummonFriendlyElementalCreatureHistory(
    Card card, Element element, int effectId) {
  HistoryTriggeredEffect function(GameState state) {
    return HistoryTriggeredEffect(
        card: card.id,
        triggeredEffectId: effectId,
        data: [state.stack.last.id]);
  }

  return function;
}
