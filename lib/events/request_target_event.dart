import '../effects/effect.dart';
import '../effects/i_targeted.dart';
import '../effects/target/target.dart';
import '../exceptions/event_exception.dart';
import '../models/game_state.dart';
import '../state_changes/state_change.dart';
import 'event.dart';

/// Requests a target from a player for an effect.
class RequestTargetEvent extends Event {
  /// The effect to be filled.
  final Effect effect;

  /// Target the result must conform to.
  final Target target;

  /// [Effect] to be filled, and its [target] pattern.
  const RequestTargetEvent({
    required this.effect,
    required this.target,
    bool resolved = false,
  })  : assert(effect is ITargeted),
        super(resolved: resolved);

  @override
  List<StateChange> apply(GameState state) => throw const EventException(
      'RequestTargetEvent error: This should be filled and never applied.');

  @override
  RequestTargetEvent get copyResolved =>
      RequestTargetEvent(effect: effect, target: target, resolved: true);

  @override
  List<Object> get props => [effect, target, resolved];
}