import 'package:meta/meta.dart';

import '../event/event.dart';
import '../game_state/game_state.dart';
import 'state_change.dart';

class ResolveEventStateChange extends StateChange {
  final Event event;
  const ResolveEventStateChange({@required this.event});

  @override
  GameState apply(GameState state) {
    // TODO: implement apply
    throw UnimplementedError();
  }

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
