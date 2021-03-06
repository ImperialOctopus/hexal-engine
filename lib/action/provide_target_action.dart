import '../effect/targeted_effect.dart';
import '../exceptions/action_exception.dart';
import '../model/enums/event_state.dart';
import '../model/game_state.dart';
import '../state_change/priority_state_change.dart';
import '../state_change/provide_target_state_change.dart';
import '../state_change/state_change.dart';
import 'action.dart';

/// Provides target to a request.
class ProvideTargetAction extends Action {
  /// Targets provided by player.
  final List<int> targets;

  /// Provides targets to a request.
  const ProvideTargetAction({required this.targets});

  @override
  void validate(GameState state) {
    // Check stack isn't empty.
    if (state.stack.isEmpty || state.stack.last is! TargetedEffect) {
      throw const ActionException(
          'ProvideTargetAction: Top event in stack is not a TargetedEffect.');
    }
    final _request = state.stack.last as TargetedEffect;
    // Request must not be filled.
    if (_request.targetFilled) {
      throw const ActionException(
          'ProvideTargetAction: Target has already been provided.');
    }
    // Check request is still unresolved.
    if (_request.state != EventState.unresolved) {
      throw const ActionException(
          'ProvideTargetAction: TargetedEffect has already resolved.');
    }
    // Check request belongs to the priority player.
    if (_request.target.controller != state.priorityPlayer) {
      throw const ActionException(
          'ProvideTargetAction: TargetedEffect is not controlled by the priority player.');
    }
    // Check provided targets are valid.
    if (!(_request.target.targetValid(state, targets))) {
      throw const ActionException(
          'ProvideTargetAction: Provided target is not valid.');
    }
  }

  @override
  List<StateChange> apply(GameState state) {
    validate(state);

    return [
      ProvideTargetStateChange(
        targets: targets,
      ),
      PriorityStateChange(player: state.activePlayer),
    ];
  }

  /// Whether this action can be auto passed.
  static bool canAutoPass(GameState state) {
    if (state.stack.isEmpty || state.stack.last is! TargetedEffect) {
      return true;
    }
    final _request = state.stack.last as TargetedEffect;
    // Request must not be filled.
    if (_request.targetFilled ||
        _request.state != EventState.unresolved ||
        _request.target.controller != state.priorityPlayer) {
      return true;
    }
    return false;
  }

  @override
  List<Object> get props => [targets];

  /// Create from json.
  static ProvideTargetAction fromJson(List<dynamic> json) =>
      ProvideTargetAction(
        targets: (json[0] as List<dynamic>).cast<int>().toList(),
      );
}
