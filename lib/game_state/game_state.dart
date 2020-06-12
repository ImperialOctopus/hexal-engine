import 'package:equatable/equatable.dart';
import 'package:hexal_engine/state_change/remove_stack_event_state_change.dart';
import 'package:meta/meta.dart';

import '../actions/action.dart';
import '../event/event.dart';
import '../objects/card_object.dart';
import '../objects/player_object.dart';
import '../state_change/state_change.dart';
import 'game_info.dart';
import 'game_over_state.dart';
import 'turn_phase.dart';

class GameState extends Equatable {
  final GameInfo gameInfo;
  final GameOverState gameOverState;
  final List<CardObject> cards;
  final List<Event> stack;
  final PlayerObject activePlayer;
  final PlayerObject priorityPlayer;
  final TurnPhase turnPhase;

  PlayerObject get notPriorityPlayer => (priorityPlayer == gameInfo.player1)
      ? gameInfo.player2
      : gameInfo.player1;
  PlayerObject get notActivePlayer =>
      (activePlayer == gameInfo.player1) ? gameInfo.player2 : gameInfo.player1;

  const GameState({
    @required this.gameInfo,
    @required this.gameOverState,
    @required this.cards,
    @required this.stack,
    @required this.activePlayer,
    @required this.priorityPlayer,
    @required this.turnPhase,
  });

  List<StateChange> applyAction(Action action) => action.apply(this);

  GameState applyStateChanges(List<StateChange> changes) =>
      changes.fold(this, (currentState, change) => change.apply(currentState));

  List<StateChange> resolveTopStackEvent() => stack.last.apply(this)
    ..add(RemoveStackEventStateChange(event: stack.last));

  GameState copyWith({
    GameInfo gameInfo,
    GameOverState gameOverState,
    List<CardObject> cards,
    List<Event> stack,
    PlayerObject activePlayer,
    PlayerObject priorityPlayer,
    TurnPhase turnPhase,
  }) {
    return GameState(
      gameInfo: gameInfo ?? this.gameInfo,
      gameOverState: gameOverState ?? this.gameOverState,
      cards: cards ?? this.cards,
      stack: stack ?? this.stack,
      activePlayer: activePlayer ?? this.activePlayer,
      priorityPlayer: priorityPlayer ?? this.priorityPlayer,
      turnPhase: turnPhase ?? this.turnPhase,
    );
  }

  @override
  List<Object> get props => [
        gameInfo,
        gameOverState,
        cards,
        stack,
        activePlayer,
        priorityPlayer,
        turnPhase
      ];
}
